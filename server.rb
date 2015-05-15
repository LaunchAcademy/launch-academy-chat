require "sinatra"
require "pg"

configure :development do
  set :db_config, { dbname: "messages" }
end

configure :production do
  uri = URI.parse(ENV["DATABASE_URL"])
  set :db_config, {
    host: uri.host,
    port: uri.port,
    dbname: uri.path.delete('/'),
    user: uri.user,
    password: uri.password
  }
end

def db_connection
  connection = PG.connect(settings.db_config)
  begin
    yield(connection)
  ensure
    connection.close
  end
end

def exec_query(sql, values = [])
  result = nil
  begin
    db_connection do |connection|
      result = connection.exec(sql, values).to_a
    end
  rescue PG::Error => err
    puts "server.rb: error executing SQL statement"
    puts "\tsql: '#{sql}'"
    puts "\tvalues: #{values}"
    puts "\terror: #{err}"
  end
  result
end

get "/" do
  redirect to("/messages")
end

get "/messages" do
  sql = <<-SQL
    SELECT * FROM messages LIMIT 10;
  SQL
  messages = exec_query(sql)
  erb :"messages/index", locals: { messages: messages }
end

get "/messages/new" do
  erb :"messages/new"
end

post "/messages" do
  sql = <<-SQL
    INSERT INTO messages(content, created_at) VALUES($1, $2)
      RETURNING id;
  SQL
  values = [
    params["content"],
    DateTime.now
  ]
  result = exec_query(sql, values)

  redirect to("/messages")
end
