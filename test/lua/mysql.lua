local function close_db(db)
    if not db then
        return
    end
    db:close()
end

local mysql = require("resty.mysql")
--创建实例
local db, err = mysql:new()
if not db then
    ngx.say("new mysql error : ", err)
    return
end
--设置超时时间(毫秒)
db:set_timeout(1000)

local props = {
    host = "192.168.56.102",
    port = 3306,
    database = "gptg",
    charset = "utf8",
    user = "root"
}

local res, err, errno, sqlstate = db:connect(props)

if not res then
   ngx.say("connect to mysql error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
   return close_db(db)
end

--调用存储过程
local select_sql = "call p_22001_UserStatu('geaoyu','sdf' , '0' , 'van')"
res, err, errno, sqlstate = db:query(select_sql)
if not res then
   ngx.say("drop table error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
   return close_db(db)
end

for i, row in ipairs(res) do
   for name, value in pairs(row) do
     ngx.say("select row ", i, " : ", name, " = ", value, "<br/>")
   end
end

close_db(db)
