local mysql = require("./mysql")

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
    is ,mysql = mysql.music_mysql()
    if not is then
        data["state"] = false
        data["msg"] = "数据库错误"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    is,id = mysql.exec().sql("INSERT INTO `users` (`id`, `user`, `password`) VALUES (null, ?, ?)",user,strings.md5(password))
    if not is then
        data["state"] = false
        data["msg"] = "注册失败"
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    data["state"] = true
    data["msg"] = "注册成功"
    data["id"] = id
    request.StatusCode(200)
    request.Write(json.encode(data))
end