
function music_mysql()
    local ini = require("ini")
    if ini.open("config.ini") then
        return require("mysql").open(
                ini.get("mysql","user"),
                ini.get("mysql","password"),
                ini.get("mysql","ip"),
                ini.get("mysql","port"),
                ini.get("mysql","database")
        )
    end
end

function main(request)
    request.Template("index.html",{
        Title="Music Love",
    })
end