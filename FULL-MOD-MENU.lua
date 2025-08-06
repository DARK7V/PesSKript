-- 🏷️ رقم نسخة السكربت
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
-- 🌍 دوال الشبكة
-----------------------------------------------------
function getIP()
    local response = gg.makeRequest("https://api.ipify.org")
    if response and response.content then return response.content else return nil end
end

function logUser(code, ip)
    local url = "https://script.google.com/macros/s/AKfycbzacHqX0YHatMzZBt7f9w4knnQYbGCiB5b3uGBKhF8MF1wz1V_0oGJrIcyFzzKRCuea8Q/exec"
    url = url .. "?code=" .. code .. "&device=" .. ip
    gg.makeRequest(url)
end

-----------------------------------------------------
-- 🔧 ✨ وضع الصيانة ✨
-----------------------------------------------------
local maintenanceMode = false   -- لو true = الهاك واقف لكل الناس ماعدا ULTRA-VIP و ULTRA-MASTER

if maintenanceMode then
    if not (isUltraVIP or isUltraMaster) then
        os.remove(ipFile)
        gg.alert("⚠️ الهاك تحت الصيانة حاليًا 🔧\n🔄 حاول مرة تانية بعد التحديث.")
        os.exit()
    else
        gg.alert("🔥 في تحديثات شغّالة لكن رتبتك تسمحلك بالدخول.")
    end
end

-----------------------------------------------------
-- 📡 قراءة/تخزين الـIP
-----------------------------------------------------
local savedIP = nil
local f = io.open(ipFile, "r")
if f then savedIP = f:read("*a") f:close() end

local currentIP = getIP()
if not currentIP then gg.alert("❌ فشل في جلب الـIP!") os.exit() end

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
    if isUltraVIP then
        gg.alert("🔥 أهلاً بالـ ULTRA‑VIP – كل الصلاحيات مفتوحة لك!")
    elseif isUltraMaster then
        gg.alert("👑 أهلاً بالـ ULTRA‑MASTER – أقوى رتبة! عندك صلاحيات مطلقة 🚀")
    elseif isVIP then
        gg.toast("✅ تم تسجيلك كـ VIP – صلاحية 3 أيام")
    elseif isLoden then
        gg.toast("✅ تم تسجيلك كـ Loden – صلاحية أسبوع")
    elseif isMaster then
        gg.toast("✅ تم تسجيلك كـ MASTER – مدى الحياة")
    end
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
local savedR10Luck = {}  -- 🆕 لحفظ قيم حظ رونالدينيو

-----------------------------------------------------
-- 🕹️ دوال السرعة
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
        if choice == nil or choice == 8 then break
        elseif choice >= 1 and choice <= 7 then
            gg.setSpeed(speeds[choice])
            gg.alert("⚡ تم ضبط السرعة: " .. speeds[choice] .. "x")
        end
    end
end

-----------------------------------------------------
-- 🎯 القائمة الرئيسية
-----------------------------------------------------
while true do
    local now = os.time()
if not (isMaster or isUltraMaster) and EXPIRE_DATE and now > EXPIRE_DATE then
    -- 🗑 حذف ملفات التسجيل بالكامل
    os.remove(ipFile)
    os.remove(saveFile)
    
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
            '🍀 تفعيل حظ رونالدينيو',
            '🚫 إيقاف حظ رونالدينيو',
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

        -------------------------------------------------
        -- ✅ تسديد قوي + حارس ضعيف
        -------------------------------------------------
        if menu == 1 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedShoot = gg.getResults(10)
            gg.editAll("1066399999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("✅ تم تفعيل التسديد القوي")

        -------------------------------------------------
        -- ❌ إيقاف التسديد القوي
        -------------------------------------------------
        elseif menu == 2 then
            if #savedShoot > 0 then
                gg.setValues(savedShoot)
                gg.toast("❌ رجع التسديد القوي للأصل")
            else
                gg.toast("⚠️ مفيش قيم محفوظة للتسديد!")
            end

        -------------------------------------------------
        -- ⚽ استحواذ 100%
        -------------------------------------------------
        elseif menu == 3 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedPossession = gg.getResults(10)
            gg.editAll("1063199999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("⚽✅ تم تفعيل الاستحواذ 100%")

        -------------------------------------------------
        -- ♻️ إيقاف الاستحواذ
        -------------------------------------------------
        elseif menu == 4 then
            if #savedPossession > 0 then
                gg.setValues(savedPossession)
                gg.toast("♻️ رجع الاستحواذ الأصلي")
            else
                gg.toast("⚠️ مفيش قيم محفوظة للاستحواذ!")
            end

        -------------------------------------------------
        -- 🍀 تفعيل نسبة الحظ
        -------------------------------------------------
        elseif menu == 5 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedLuck = gg.getResults(10)
            gg.editAll("1066999999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("🍀✅ تم تفعيل نسبة الحظ!")

        -------------------------------------------------
        -- 🚫 إيقاف نسبة الحظ
        -------------------------------------------------
        elseif menu == 6 then
            if #savedLuck > 0 then
                gg.setValues(savedLuck)
                gg.toast("🚫 رجعت قيم الحظ للأصل ✅")
            else
                gg.toast("⚠️ مفيش قيم محفوظة للحظ!")
            end

        -------------------------------------------------
        -- 🍀 تفعيل حظ رونالدينيو
        -------------------------------------------------
        elseif menu == 7 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedR10Luck = gg.getResults(10)
            gg.editAll("1069099999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("🍀✅ تم تفعيل حظ رونالدينيو!")

        -------------------------------------------------
        -- 🚫 إيقاف حظ رونالدينيو
        -------------------------------------------------
        elseif menu == 8 then
            if #savedR10Luck > 0 then
                gg.setValues(savedR10Luck)
                gg.toast("🚫 رجع حظ رونالدينيو للأصل ✅")
            else
                gg.toast("⚠️ مفيش قيم محفوظة لحظ رونالدينيو!")
            end

        -------------------------------------------------
        -- ⏩ سرعة ×2 (Ultra-VIP & Ultra-Master)
        -------------------------------------------------
        elseif (isUltraVIP or isUltraMaster) and menu == 9 then
            gg.setSpeed(2.0)
            gg.alert("⏩ الوقت مسرع ×2")

        -------------------------------------------------
        -- ⏸ إيقاف الوقت
        -------------------------------------------------
        elseif (isUltraVIP or isUltraMaster) and menu == 10 then
            gg.setSpeed(1.0)
            gg.alert("⏸ تم إيقاف سرعة الوقت")

        -------------------------------------------------
        -- ⏱️ تايمر
        -------------------------------------------------
        elseif (isUltraVIP or isUltraMaster) and menu == 11 then
            activateTimer()

        -------------------------------------------------
        -- ⚡ قائمة السرعة
        -------------------------------------------------
        elseif (isUltraVIP or isUltraMaster) and menu == 12 then
            speedMenu()

        -------------------------------------------------
        -- 🗑 مسح الكود
        -------------------------------------------------
        elseif ((not isUltraVIP and not isUltraMaster) and menu == 9) or ((isUltraVIP or isUltraMaster) and menu == 13) then
            os.remove(ipFile)
            os.remove(saveFile)
            gg.alert("🗑 تم مسح الكود – هتحتاج تدخله تاني في التشغيل الجاي.")
            os.exit()

        -------------------------------------------------
        -- 🚪 خروج
        -------------------------------------------------
        elseif ((not isUltraVIP and not isUltraMaster) and menu == 10) or ((isUltraVIP or isUltraMaster) and menu == 14) then
            gg.toast("👋 تم الخروج من الأداة.")
            os.exit()
        end
    end

    gg.sleep(400)
end
