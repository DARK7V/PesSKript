-- 🏷️ رقم نسخة السكربت (غيره كل ما تعمل تحديث)
local SCRIPT_VERSION = "4.1"

-----------------------------------------------------
-- 🌍 دالة تسجيل المستخدمين في Google Sheets
-----------------------------------------------------
function logUser(code)
    local url = "https://script.google.com/macros/s/AKfycbzacHqX0YHatMzZBt7f9w4knnQYbGCiB5b3uGBKhF8MF1wz1V_0oGJrIcyFzzKRCuea8Q/exec"
    -- نجيب معلومات الهدف
    local info = gg.getTargetInfo()
    local device_info = info.packageName .. "_" .. (info.x64 and "64bit" or "32bit")
    url = url .. "?code=" .. code .. "&device=" .. device_info
    gg.makeRequest(url)
end

-- 🔒 طلب كلمة السر (إدخال واحد)
local password = gg.prompt({
    [1] = '🔑 ادخل كلمة السر هنا:'
}, {}, {[1] = 'text'})

if not password then
    gg.alert("❌ لم يتم إدخال كلمة السر!")
    os.exit()
end

local pass = password[1]

-- ✅ أنواع كلمات السر
local isMaster      = (pass == "MASTER")
local isVIP         = (pass == "VIP")
local isLoden       = (pass == "Loden")
local isUltraVIP    = (pass == "ULTRA-VIP")
local isUltraMaster = (pass == "ULTRA-MASTER")  -- 🚀 أعلى رتبة

-- 📥 تسجيل المستخدم في Google Sheets
logUser(pass)

if not (isMaster or isVIP or isLoden or isUltraVIP or isUltraMaster) then
    gg.alert("❌ كلمة السر غلط! حاول مرة تانية.")
    os.exit()
end

-- ✅ رسائل التفعيل
if isUltraMaster then
    gg.alert("👑🔥 ULTRA MASTER – أقوى رتبة 🔓\n🎁 كل الصلاحيات شغالة للأبد!")
elseif isMaster then
    gg.alert("✅ MASTER – الأداة شغالة 🔓")
elseif isVIP then
    gg.alert("✅ VIP – الصلاحية 3 أيام ⏳")
elseif isLoden then
    gg.alert("✅ Loden – الصلاحية 7 أيام ⏳")
elseif isUltraVIP then
    gg.alert("🌟 ULTRA VIP – الصلاحية 7 أيام + ميزات خاصة")
end

gg.toast("✅ تم تفعيل الأداة!")

-- 📂 ملفات التخزين
local saveFile    = "/storage/emulated/0/.gg_script_date.txt"
local versionFile = "/storage/emulated/0/.gg_script_version.txt"

-----------------------------------------------------
-- 🔧 ✨ وضع الصيانة ✨
-----------------------------------------------------
local maintenanceMode = true   -- لو true = الهاك واقف لكل الناس ماعدا ULTRA-VIP و ULTRA-MASTER

if maintenanceMode and not (isUltraVIP or isUltraMaster) then
    os.remove(versionFile)
    gg.alert("⚠️ الهاك موقوف مؤقتًا للتحديثات 🔧\n🔄 حاول مرة تانية بعد شوية.")
    os.exit()
elseif maintenanceMode and (isUltraVIP or isUltraMaster) then
    gg.alert("🔥 في تحديثات دلوقتي يا نجم وكلو واقف...\n❤ بس رتبتك عالية فشغال معاك!")
end

-----------------------------------------------------
-- 📆 تحديد تاريخ بداية التشغيل
local START_DATE
local file = io.open(saveFile, "r")
if file then
    START_DATE = tonumber(file:read("*a"))
    file:close()
else
    START_DATE = os.time()
    file = io.open(saveFile, "w")
    file:write(START_DATE)
    file:close()
end

-----------------------------------------------------
-- ✅ 👀 تحقق من نسخة السكربت
-----------------------------------------------------
local oldVersionFile = io.open(versionFile, "r")
local oldVersion = oldVersionFile and oldVersionFile:read("*a") or nil
if oldVersionFile then oldVersionFile:close() end

if oldVersion ~= SCRIPT_VERSION then
    if oldVersion ~= nil then
        gg.alert("✅ تم تنزيل التحديث الجديد (" .. SCRIPT_VERSION .. ")")
    end
    local vf = io.open(versionFile, "w")
    vf:write(SCRIPT_VERSION)
    vf:close()
end

-----------------------------------------------------
-- 📆 صلاحية حسب نوع الباسورد
-----------------------------------------------------
local EXPIRE_DATE = nil
if not (isMaster or isUltraMaster) then
    if isLoden or isUltraVIP then
        EXPIRE_DATE = START_DATE + (7 * 24 * 60 * 60)
    elseif isVIP then
        EXPIRE_DATE = START_DATE + (3 * 24 * 60 * 60)
    end
end

local function formatDate(timestamp)
    local date = os.date("*t", timestamp)
    return string.format("%02d/%02d/%04d", date.day, date.month, date.year)
end

if not (isMaster or isUltraMaster) then
    gg.alert("📅 صلاحية السكربت تنتهي يوم: " .. formatDate(EXPIRE_DATE))
else
    if isUltraMaster then
        gg.alert("♾️ ULTRA MASTER صلاحية دائمة – مش هيقف أبداً ✅")
    end
end

-- 📦 جداول حفظ القيم
local savedValues = {}
local savedPossession = {}
local savedLuck = {}

-----------------------------------------------------
-- 🕹️ وظائف السرعة (ULTRA-VIP & ULTRA-MASTER)
-----------------------------------------------------
function activateTimer()
    gg.alert("⏱️ تم تفعيل تايمر 6:15 دقيقة...")
    gg.sleep(375000)
    gg.alert("🚀 تايمر انتهى! تفعيل السرعة ×10")
    gg.setSpeed(10.0)
end

function speedMenu()
    while true do
        local choice = gg.choice({
            "🐢 سرعة ربع (0.25x)",
            "🚶 سرعة نص (0.5x)",
            "🚗 سرعة طبيعية (1x)",
            "🚀 سرعة 2x",
            "🔥 سرعة 3x",
            "⚡ سرعة 5x",
            "💥 سرعة 10x",
            "🔙 رجوع"
        }, nil, "👑 تحكم الزمن ⏳")

        local speeds = {0.25, 0.5, 1.0, 2.0, 3.0, 5.0, 10.0}
        if choice == nil or choice == 8 then
            break
        elseif choice >= 1 and choice <= 7 then
            gg.setSpeed(speeds[choice])
            gg.alert("⚡ تم ضبط السرعة: " .. speeds[choice] .. "x")
        end
    end
end

-----------------------------------------------------
-- 🎯 حلقة القائمة الرئيسية
-----------------------------------------------------
while true do
    local now = os.time()

    if not (isMaster or isUltraMaster) and now > EXPIRE_DATE then
        gg.alert("❌ انتهت صلاحية السكربت!")
        os.exit()
    end

    if gg.isVisible(true) then
        gg.setVisible(false)

        local menuItems = {
            '✅ تسديد قوي + حارس ضعيف',
            '❌ إيقاف التسديد القوي',
            '⚽ استحواذ 100%',
            '♻️ إيقاف الاستحواذ',
            '🍀 تفعيل نسبة الحظ',
            '🚫 إيقاف نسبة الحظ',
        }

        if (isUltraVIP or isUltraMaster) then
            table.insert(menuItems, "⏩ سرعة ×2")
            table.insert(menuItems, "⏸ إيقاف الوقت")
            table.insert(menuItems, "⏱️ تايمر 6:15 دقيقة + تسريع ×10")
            table.insert(menuItems, "⚡ قائمة السرعة المتقدمة")
        end

        table.insert(menuItems, '🚪 خروج')

        local menu = gg.choice(menuItems, nil, '👑 قائمة أدوات لودن 🇮🇶')

        if menu == 1 then    
            gg.setRanges(gg.REGION_C_DATA)    
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)    
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)    
            gg.refineNumber("1065353216", gg.TYPE_DWORD)    

            local results = gg.getResults(10)    
            for i, v in ipairs(results) do    
                table.insert(savedValues, {address = v.address, flags = gg.TYPE_DWORD, value = v.value})    
            end    

            gg.editAll("1066399999", gg.TYPE_DWORD)    
            gg.clearResults()    
            gg.toast("✅ تم تفعيل التسديد القوي")    

        elseif menu == 2 then    
            gg.setRanges(gg.REGION_C_DATA)    
            gg.searchNumber("1066399999", gg.TYPE_DWORD)    
            gg.getResults(10)    
            gg.editAll("1065353216", gg.TYPE_DWORD)    
            gg.clearResults()    
            gg.toast("❌ تم إيقاف التسديد القوي!")    

        elseif menu == 3 then    
            gg.setRanges(gg.REGION_C_DATA)    
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)    
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)    
            gg.refineNumber("1065353216", gg.TYPE_DWORD)    

            local results = gg.getResults(10)    
            savedPossession = {}    
            for i, v in ipairs(results) do    
                table.insert(savedPossession, {address = v.address, flags = gg.TYPE_DWORD, value = v.value})    
            end    

            gg.editAll("1063199999", gg.TYPE_DWORD)    
            gg.clearResults()    
            gg.toast("⚽✅ تم تفعيل الاستحواذ 100%")    

        elseif menu == 4 then    
            if #savedPossession > 0 then    
                gg.setValues(savedPossession)    
                gg.toast("♻️✅ رجع الاستحواذ الأصلي")    
            else    
                gg.toast("⚠️ مفيش قيم محفوظة للاستحواذ!")    
            end    

        elseif menu == 5 then    
            gg.setRanges(gg.REGION_C_DATA)    
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)    
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)    
            gg.refineNumber("1065353216", gg.TYPE_DWORD)    

            local results = gg.getResults(10)    
            savedLuck = {}    
            for i, v in ipairs(results) do    
                table.insert(savedLuck, {address = v.address, flags = gg.TYPE_DWORD, value = v.value})    
            end    

            gg.editAll("1066999999", gg.TYPE_DWORD)    
            gg.clearResults()    
            gg.toast("🍀✅ تم تفعيل نسبة الحظ!")    

        elseif menu == 6 then    
            if #savedLuck > 0 then    
                gg.setValues(savedLuck)    
                gg.toast("🚫 تم إيقاف نسبة الحظ ورجوع القيم الأصلية ✅")    
            else    
                gg.toast("⚠️ مفيش قيم محفوظة للحظ!")    
            end    

        elseif (isUltraVIP or isUltraMaster) and menu == 7 then
            gg.setSpeed(2.0)
            gg.alert("⏩ الوقت مسرع ×2")

        elseif (isUltraVIP or isUltraMaster) and menu == 8 then
            gg.setSpeed(0.0)
            gg.alert("⏸ تم إيقاف الوقت")

        elseif (isUltraVIP or isUltraMaster) and menu == 9 then
            activateTimer()

        elseif (isUltraVIP or isUltraMaster) and menu == 10 then
            speedMenu()

        elseif ((not isUltraVIP and not isUltraMaster) and menu == 7) or ((isUltraVIP or isUltraMaster) and menu == 11) then
            gg.toast("👋 تم الخروج من الأداة.")
            os.exit()
        end
    end

    gg.sleep(400)
end
