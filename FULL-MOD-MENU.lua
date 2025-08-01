
local SCRIPT_VERSION = "3.9"

-----------------------------------------------------
-- 📂 ملفات التخزين
-----------------------------------------------------
local saveFile    = "/storage/emulated/0/.gg_script_date.txt"
local versionFile = "/storage/emulated/0/.gg_script_version.txt"
local ipFile      = "/storage/emulated/0/.gg_saved_ip.txt"

-----------------------------------------------------
-- ✅ تحقق من التحديث الجديد
-----------------------------------------------------
local vf = io.open(versionFile, "r")
if vf then
    local oldVersion = vf:read("*a")
    vf:close()
    if oldVersion ~= SCRIPT_VERSION then
        gg.alert("✅ تم تنزيل التحديث الجديد ("..SCRIPT_VERSION..")")
        local wf = io.open(versionFile, "w")
        wf:write(SCRIPT_VERSION)
        wf:close()
    end
else
    local wf = io.open(versionFile, "w")
    wf:write(SCRIPT_VERSION)
    wf:close()
    gg.alert("✅ تم تنزيل التحديث الجديد ("..SCRIPT_VERSION..")")
end

-----------------------------------------------------
-- 🌍 دوال الشبكة (مع محاولة متعددة)
-----------------------------------------------------
function getIP()
    local urls = {
        "https://api.ipify.org",
        "https://ifconfig.me/ip"
    }
    for _, url in ipairs(urls) do
        local response = gg.makeRequest(url)
        if response and response.content and response.content ~= "" then
            return response.content
        end
    end
    return nil
end

function logUser(code, ip)
    local url = "https://script.google.com/macros/s/AKfycbzacHqX0YHatMzZBt7f9w4knnQYbGCiB5b3uGBKhF8MF1wz1V_0oGJrIcyFzzKRCuea8Q/exec"
    url = url .. "?code=" .. code .. "&device=" .. ip
    gg.makeRequest(url)
end

-----------------------------------------------------
-- 🔧 ✨ وضع الصيانة ✨
-----------------------------------------------------
local maintenanceMode = true   -- لو true = الهاك واقف لكل الناس ماعدا ULTRA-VIP و ULTRA-MASTER

if maintenanceMode then
    
        os.remove(ipFile)
        gg.alert("⚠️ الهاك تحت الصيانة حاليًا 🔧\n🔄 حاول مرة تانية بعد التحديث.")
        os.exit()
    else
        gg.alert("🔥 في تحديثات شغّالة لكن رتبتك تسمحلك بالدخول.")
    end
end

-----------------------------------------------------
-- 📡 قراءة/تخزين الـIP (مع إعادة المحاولة)
-----------------------------------------------------
local savedIP = nil
local f = io.open(ipFile, "r")
if f then savedIP = f:read("*a") f:close() end

local currentIP = getIP()

-- 🛠️ إعادة المحاولة 3 مرات لو فشل
if not currentIP then
    gg.toast("⚠️ محاولة أولى فشلت.. بنعيد المحاولة 🔄")
    gg.sleep(1500)
    currentIP = getIP()
end
if not currentIP then
    gg.toast("⚠️ محاولة ثانية فشلت.. بنعيد المحاولة 🔄")
    gg.sleep(1500)
    currentIP = getIP()
end

-- 🚨 لو فشل نهائيًا → خيار إدخال يدوي
if not currentIP then
    local manual = gg.prompt({"🌍 السيرفر فشل يجيب IP جهازك.\n✍️ اكتب الـIP يدوي (مثلاً: 41.232.54.120):"}, {}, {"text"})
    if not manual then
        gg.alert("❌ مفيش IP – مش قادر أكمل!")
        os.exit()
    else
        currentIP = manual[1]
        gg.toast("✅ تم تسجيل الـIP اليدوي: " .. currentIP)
    end
end

-----------------------------------------------------
-- 🔒 التحقق بالباسورد
-----------------------------------------------------
local pass = nil
local isMaster, isVIP, isLoden, isUltraVIP, isUltraMaster = false,false,false,false,false

if savedIP == nil then
    local password = gg.prompt({"🔑 ادخل كلمة السر هنا:"}, {}, {"text"})
    if not password then gg.alert("❌ لم يتم إدخال كلمة السر!") os.exit() end
    pass = password[1]

    isMaster      = (pass == "MASTER")
    isVIP         = (pass == "VIP")
    isLoden       = (pass == "Loden")
    isUltraVIP    = (pass == "ULTRA-VIP")
    isUltraMaster = (pass == "ULTRA-MASTER")

    logUser(pass, currentIP)

    if not (isMaster or isVIP or isLoden or isUltraVIP or isUltraMaster) then
        gg.alert("❌ كلمة السر غلط!")
        os.exit()
    end

    local fw = io.open(ipFile, "w")
    fw:write(currentIP .. "|" .. pass)
    fw:close()
    gg.toast("✅ تم تسجيل جهازك بالـIP: " .. currentIP)
else
    local fw = io.open(ipFile, "r")
    local content = fw:read("*a")
    fw:close()
    local parts = {}
    for word in string.gmatch(content, "([^|]+)") do table.insert(parts, word) end
    currentIP = parts[1]
    pass = parts[2] or "غير معروف"
    isMaster      = (pass == "MASTER")
    isVIP         = (pass == "VIP")
    isLoden       = (pass == "Loden")
    isUltraVIP    = (pass == "ULTRA-VIP")
    isUltraMaster = (pass == "ULTRA-MASTER")
end

-----------------------------------------------------
-- 📆 حساب الصلاحية
-----------------------------------------------------
local START_DATE
local file = io.open(saveFile, "r")
if file then START_DATE = tonumber(file:read("*a")) file:close()
else
    START_DATE = os.time()
    file = io.open(saveFile, "w") file:write(START_DATE) file:close()
end

local EXPIRE_DATE = nil
if not (isMaster or isUltraMaster) then
    if isLoden or isUltraVIP then
        EXPIRE_DATE = START_DATE + (7 * 24 * 60 * 60)
    elseif isVIP then
        EXPIRE_DATE = START_DATE + (3 * 24 * 60 * 60)
    end
end

local function formatDate(timestamp)
    if not timestamp then return "مدى الحياة ✅" end
    local date = os.date("*t", timestamp)
    return string.format("%02d/%02d/%04d", date.day, date.month, date.year)
end

-----------------------------------------------------
-- 📦 حفظ القيم
-----------------------------------------------------
local savedShoot = {}
local savedPossession = {}
local savedLuck = {}
local savedRonaldo = {}   -- ✅ إضافة متغير لرونالدينهو

-----------------------------------------------------
-- 🕹️ دوال السرعة
-----------------------------------------------------
function activateTimer()
    gg.alert("⏱️ تم تفعيل تايمر 6:15 دقيقة...")
    gg.sleep(375000)
    gg.alert("🚀 تايمر انتهى! تفعيل السرعة ×10")
    gg.setSpeed(10.0)
end

-----------------------------------------------------
-- 🎯 القائمة الرئيسية
-----------------------------------------------------
while true do
    local now = os.time()
    if not (isMaster or isUltraMaster) and EXPIRE_DATE and now > EXPIRE_DATE then
        os.remove(ipFile)
        gg.alert("❌ انتهت صلاحية الكود! لازم تدخل كود جديد.")
        os.exit()
    end

    if gg.isVisible(true) then
        gg.setVisible(false)

        local header = "👑 قائمة أدوات لودن 🇮🇶\n📜 الكود: " .. tostring(pass) .. "\n📆 الصلاحية: " .. formatDate(EXPIRE_DATE)

        local menuItems = {
            '✅ تسديد قوي + حارس ضعيف',
            '❌ إيقاف التسديد القوي',
            '⚽ استحواذ 100%',
            '♻️ إيقاف الاستحواذ',
            '🍀 تفعيل نسبة الحظ',
            '🚫 إيقاف نسبة الحظ',
            '🎨 كولر + رونالدينهو 65% ❤️‍🔥',  -- ✅ جديد
            '🚫 إيقاف نسبة حظ رونالدينهو',    -- ✅ جديد
        }

        if (isUltraVIP or isUltraMaster) then
            table.insert(menuItems, "⏩ سرعة ×2")
            table.insert(menuItems, "⏸ إيقاف سرعة  الوقت")
            table.insert(menuItems, "⏱️ تايمر 6:15 دقيقة + تسريع ×10")
            table.insert(menuItems, "⚡ قائمة السرعة المتقدمة")
        end

        table.insert(menuItems, "🗑 مسح الكود")
        table.insert(menuItems, "🚪 خروج")

        local menu = gg.choice(menuItems, nil, header)

        if menu == 1 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedShoot = gg.getResults(10)
            gg.editAll("1066399999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("✅ تم تفعيل التسديد القوي")
        elseif menu == 2 then
            if #savedShoot > 0 then gg.setValues(savedShoot) gg.toast("❌ رجع التسديد القوي للأصل") end
        elseif menu == 3 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedPossession = gg.getResults(10)
            gg.editAll("1063199999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("⚽✅ تم تفعيل الاستحواذ 100%")
        elseif menu == 4 then
            if #savedPossession > 0 then gg.setValues(savedPossession) gg.toast("♻️ رجع الاستحواذ الأصلي") end
        elseif menu == 5 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
gg.refineNumber("1065353216", gg.TYPE_DWORD)
savedLuck = gg.getResults(10)
gg.editAll("1070000000", gg.TYPE_DWORD)
gg.clearResults()
gg.toast("🍀✅ تم تفعيل الحظ 100% – أفضل اللاعبين هيظهروا!")
        elseif menu == 6 then
            if #savedLuck > 0 then gg.setValues(savedLuck) gg.toast("🚫 رجعت قيم الحظ للأصل ✅") end
        elseif menu == 7 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedRonaldo = gg.getResults(10)
            gg.editAll("1065599999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("🎨✅ كولر + رونالدينهو 65% شغّال!")
        elseif menu == 8 then
            if #savedRonaldo > 0 then gg.setValues(savedRonaldo) gg.toast("🚫 رجعت قيم رونالدينهو للأصل ✅") end
        elseif ((not isUltraVIP and not isUltraMaster) and menu == 9) or ((isUltraVIP or isUltraMaster) and menu == 13) then
            os.remove(ipFile)
            os.remove(saveFile)
            gg.alert("🗑 تم مسح الكود – هتحتاج تدخله تاني في التشغيل الجاي.")
            os.exit()
        elseif ((not isUltraVIP and not isUltraMaster) and menu == 10) or ((isUltraVIP or isUltraMaster) and menu == 14) then
            gg.toast("👋 تم الخروج من الأداة.")
            os.exit()
        end
    end

    gg.sleep(400)
end
