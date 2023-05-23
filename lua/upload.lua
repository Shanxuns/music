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
    json = require("json")
    data = {}
    is, name = request.PostFormValue("name")
    if not is then
        data["state"] = false
        data["msg"] = "上传失败"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    is = request.FileSize(0,20)
    if not is then
        data["state"] = false
        data["msg"] = "上传失败"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    is ,mysql = music_mysql()
    if not is then
        data["state"] = false
        data["msg"] = "上传失败"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    isUser, user =request.Cookie("user")
    isPassword, password =request.Cookie("password")
    if isUser and isPassword then
        is,db = mysql.query().sql("SELECT * FROM `users` WHERE `user`=? AND `password`=?",user,password)
        if is and #db == 1 then
            is, file = request.FileName("file")
            if is then
                if file.CDF == "mp3" then
                    is = request.FileUpdate("file",db[1]["id"]..'_'..name..'_'..db[1]["user"]..'.mp3')
                    if is then
                        is,id = mysql.exec().sql("INSERT INTO `file` (`id`, `name`, `path`, `artists`) VALUES (null, ?, ?, ?);",name,db[1]["id"]..'_'..name..'_'..db[1]["user"]..'.mp3',db[1]["user"])
                        if not is then
                            data["state"] = false
                            data["msg"] = "上传失败"
                            request.StatusCode(200)
                            request.Write(json.encode(data))
                            return
                        end
                        data["state"] = true
                        data["msg"] = "上传成功"
                        data["id"] = id
                        request.StatusCode(200)
                        request.Write(json.encode(data))
                        return
                    end
                end
            end
        end
    end
    data["state"] = false
    data["msg"] = "上传失败"
    request.StatusCode(200)
    request.Write(json.encode(data))
end