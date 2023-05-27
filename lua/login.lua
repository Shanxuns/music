local mysql = require("./mysql_config")

function main(request)
    data = {}
    json = require("json")
    strings = require("strings")
    is, user = request.Query("user")
    if not is then
        data["state"] = false
        data["msg"] = "请输入用户名"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    is, password = request.Query("password")
    if not is then
        data["state"] = false
        data["msg"] = "请输入密码"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    is ,mysql = music_mysql()
    if not is then
        data["state"] = false
        data["msg"] = "数据库错误"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    is,db = mysql.query().sql("SELECT * FROM `users` WHERE `user`=? AND `password`=?",user,strings.md5(password))
    if not is then
        data["state"] = false
        data["msg"] = "查询器错误"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    if #db == 0 then
        data["state"] = false
        data["msg"] = "账号或密码错误"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    request.SetCookie("user",db[1]["user"])
    request.SetCookie("password",db[1]["password"])
    data["state"] = true
    data["msg"] = "登陆成功"
    data["data"] = {
        user = db[1]["user"],
        password = db[1]["password"],
    }
    request.StatusCode(200)
    request.Write(json.encode(data))
end