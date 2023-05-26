local mysql = require("./mysql")

function main(request)
    json = require("json")
    is, id = request.Query("id")
    data = {}
    if not is then
        data["state"] = false
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    is ,mysql = music_mysql()
    if not is then
        data["state"] = false
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    isUser, user =request.Cookie("user")
    isPassword, password =request.Cookie("password")
    if isUser and isPassword then
        is,db = mysql.query().sql("SELECT * FROM `users` WHERE `user`=? AND `password`=?",user,password)
        if is and #db == 1 then
            is,db = mysql.query().sql("SELECT path FROM file WHERE id = ?",id)
            if is and #db == 1 then
                is = request.DownFile(db[1]["path"])
                if not is then
                    data["state"] = false
                    request.StatusCode(200)
                    request.Write(json.encode(data))
                    return
                end
                return
            end
        end
    end
    data["state"] = false
    request.StatusCode(200)
    request.Write(json.encode(data))
end