local mysql = require("./mysql_config")

function wang_yi(search)
    local http = require("http")
    local response, err = http.post("http://music.163.com/api/search/pc",{
        query="s="..search.."&offset=0&limit=30&type=1",
        headers={
            Accept="*/*",
            Host="music.163.com",
            Cookie= 'NMTID=00OnyLWkeQKWD2UwU-co3W3B5Jzc6cAAAGIP2wmnw'
        }
    })
    if err ~= nil then
        return nil
    else
        if response.status == nil then
            request_table = json.decode(response.body)
            if request_table.code ~= 200 then
                return nil
            end
            return request_table.result.songs
        end
        return nil
    end
end

function main(request)
    json = require("json")
    is, search = request.Query("search")
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
            is,db = mysql.query().sql("SELECT id,name,artists FROM file WHERE name LIKE ?",'%'..search..'%')
            if is then
                for k, v in pairs(db) do
                    db[k]["url"] = '/download.lua?id='..v["id"]
                    db[k]["picUrl"] = ''
                end
                data["data"] = db
            end

        end

    end
    local _data = wang_yi(search)
    if _data ~= nil then
        for _, v in pairs(_data) do
            if data.data == nil then
                data["data"] = {{
                    id=0,
                    name=v.name,
                    url='http://music.163.com/song/media/outer/url?id='..v.id..'.mp3',
                    picUrl=v.album.picUrl,
                    artists = v.artists[1].name
                }}
            else
                data["data"][#data["data"]+1] = {
                    id=0,
                    name=v.name,
                    url='http://music.163.com/song/media/outer/url?id='..v.id..'.mp3',
                    picUrl=v.album.picUrl,
                    artists=v.artists[1].name
                }
            end
        end
    end
    data["state"] = true
    request.StatusCode(200)
    request.Write(json.encode(data))
end