require "sinatra"
require "uri"


set :bind, "0.0.0.0"

def page_content(title)
    File.read("pages/#{title}.txt")
    rescue Errno::ENOENT
        return nil
end

def escape_content(content)
    Rack::Utils.escape_html(content)
end

def save_content(title, content)
    File.open("pages/#{title}.txt", "w") do |file|
        file.print(content)
    end
end

def delete_content(title)
    File.delete("pages/#{title}.txt")
end

get("/") do
    erb :welcome
end

get("/new") do
    erb :new
end

get "/edit/:title" do
    @title = params[:title]
    @content = page_content(@title)
    erb :edit
end

get "/pages/:title" do
    @title = params[:title]
    @content = page_content(@title)
    erb :show
end

post("/create") do
    save_content(params[:title], params[:content])
    redirect URI.escape("/pages/#{params[:title]}")
end

put("/update_page/:title") do
    @title = params[:title]
    @content = params[:content]
    save_content(@title, @content)
    redirect URI.escape("/pages/#{@title}")
end

delete("/delete/:title") do
    @title = params[:title]
    delete_content(@title)
    redirect("/")
end
