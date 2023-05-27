# music
>#### [使用LuaWeb开发,感兴趣的可以看看](https://github.com/Shanxuns/luaweb)

### 启动命令
```shell
linux: ./linux_amd64_LuaWeb ./config.ini

windows: ./windows_amd64_LuaWeb.exe ./config.ini

macOS: ./macOS_amd64_LuaWeb ./config.ini
```

![img.png](img.png)

## GET 搜索

GET /search.lua

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|search|query|string| 否 |none|

## POST 登陆

POST /login.lua

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|user|query|string| 是 |none|
|password|query|string| 是 |none|

## POST 注册

POST /register.lua

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|user|query|string| 是 |none|
|password|query|string| 是 |none|

## GET 下载

GET /download.lua

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|query|string| 否 |none|

## POST 上传

POST /upload.lua

> Body 请求参数

```yaml
file: file.mp3
name: 有何不可
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|body|body|object| 否 |none|
|» file|body|string(binary)| 是 |none|
|» name|body|string| 是 |none|
