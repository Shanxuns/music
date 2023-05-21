function music_mysql()
    return require("mysql").open("music","MrrBemxPr7WYBTwz","8.210.146.22","3306","音乐")
end

function wang_yi(search)
    local http = require("http")
    local response, err = http.post("http://music.163.com/api/search/pc",{
        query="s="..search.."&offset=0&limit=10&type=1",
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
    is,db = mysql.query().sql("SELECT id,name FROM file WHERE name LIKE ?",'%'..search..'%')
    if not is then
        data["state"] = false
        request.StatusCode(200)
        request.Write(json.encode(data))
        return
    end
    if #db >0 then
        for k, v in pairs(db) do
            db[k]["url"] = '/music/download.lua?id='..v["id"]
        end
    else
        local data = wang_yi(search)
        if data ~= nil then
            for k, v in pairs(data) do
                _db = {
                    id=0,
                    name=v.name,
                    url='http://music.163.com/song/media/outer/url?id='..v.id..'.mp3'
                }
                db[k]=_db
            end
        end
    end

    data["state"] = true
    data["data"] = db
    request.StatusCode(200)
    request.Write(json.encode(data))
end