local mysql = require("./mysql_config")

function main(request)
    request.Template("index.html",{
        Title="Music Love",
    })
end