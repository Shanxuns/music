local mysql = require("./mysql")

function main(request)
    request.Template("index.html",{
        Title="Music Love",
    })
end