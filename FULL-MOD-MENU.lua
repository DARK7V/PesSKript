-- 🏷️ رقم نسخة السكربت
local SCRIPT_VERSION = "4.0"

-- 📂 ملفات التخزين
local saveFile    = "/storage/emulated/0/.gg_script_date.txt"
local versionFile = "/storage/emulated/0/.gg_script_version.txt"
local ipFile      = "/storage/emulated/0/.gg_saved_ip.txt"
local renewFlagFile = "/storage/emulated/0/.gg_renew_flag.txt"  -- ملف متابعة التجديد

-- ✅ تحقق من التحديث الجديد
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

-- 🌍 دوال الشبكة
function getIP()
    local response = gg.makeRequest("https://api.ipify.org")
    if response and response.content then
        return response.content
    else
        return nil
    end
end

function logUser(code, ip)
    local url = "https://script.google.com/macros/s/AKfycbzacHqX0YHatMzZBt7f9w4knnQYbGCiB5b3uGBKhF8MF1wz1V_0oGJrIcyFzzKRCuea8Q/exec"
    url = url .. "?code=" .. code .. "&device=" .. ip
    gg.makeRequest(url)
end

-- 🔧 ✨ وضع الصيانة ✨
local maintenanceMode = false
if maintenanceMode then
    if not (isUltraVIP or isUltraMaster) then
        os.remove(ipFile)
        gg.alert("⚠️ الهاك تحت الصيانة حاليًا 🔧\n🔄 حاول مرة تانية بعد التحديث.")
        os.exit()
    else
        gg.alert("🔥 في تحديثات شغّالة لكن رتبتك تسمحلك بالدخول.")
    end
end

-- 📡 قراءة/تخزين الـIP
local savedIP = nil
local f = io.open(ipFile, "r")
if f then
    savedIP = f:read("*a")
    f:close()
end

local currentIP = getIP()
if not currentIP then
    gg.alert("❌ فشل في جلب الـIP!")
    os.exit()
end

-- 🔒 التحقق بالباسورد
local pass = nil
local isMaster, isVIP, isLoden, isUltraVIP, isUltraMaster = false,false,false,false,false

if savedIP == nil then
    local password = gg.prompt({"🔑 ادخل كلمة السر هنا:"}, {}, {"text"})
    if not password then
        gg.alert("❌ لم يتم إدخال كلمة السر!")
        os.exit()
    end
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
    for word in string.gmatch(content, "([^|]+)") do
        table.insert(parts, word)
    end
    currentIP = parts[1]
    pass = parts[2] or "غير معروف"
    isMaster      = (pass == "MASTER")
    isVIP         = (pass == "VIP")
    isLoden       = (pass == "Loden")
    isUltraVIP    = (pass == "ULTRA-VIP")
    isUltraMaster = (pass == "ULTRA-MASTER")
end

-- 📆 حساب الصلاحية
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

local EXPIRE_DATE = nil
if not (isMaster or isUltraMaster) then
    if isLoden or isUltraVIP then
        EXPIRE_DATE = START_DATE + (7 * 24 * 60 * 60)
    elseif isVIP then
        EXPIRE_DATE = START_DATE + (3 * 24 * 60 * 60)
    end
end

-- 🆕 التحقق من التجديد لمرة واحدة
local renewedOnce = false
local rf = io.open(renewFlagFile, "r")
if rf then
    local content = rf:read("*a")
    rf:close()
    if content == "1" then
        renewedOnce = true
    end
end

local function formatDate(timestamp)
    if not timestamp then return "مدى الحياة ✅" end
    local date = os.date("*t", timestamp)
    return string.format("%02d/%02d/%04d", date.day, date.month, date.year)
end

-- 📦 حفظ القيم
local savedShoot = {}
local savedPossession = {}
local savedLuck = {}

-- 🎯 القائمة الرئيسية
while true do
    local now = os.time()
    if not (isMaster or isUltraMaster) and EXPIRE_DATE and now > EXPIRE_DATE then
        if not renewedOnce then
            -- تجديد مرة واحدة
            START_DATE = os.time()
            if isLoden or isUltraVIP then
                EXPIRE_DATE = START_DATE + (7 * 24 * 60 * 60)
            elseif isVIP then
                EXPIRE_DATE = START_DATE + (3 * 24 * 60 * 60)
            end
            local wf = io.open(saveFile, "w")
            wf:write(START_DATE)
            wf:close()
            local rfw = io.open(renewFlagFile, "w")
            rfw:write("1")
            rfw:close()
            renewedOnce = true
            gg.alert("♻️ تم تجديد صلاحية الكود لمرة واحدة فقط! ✅\n📆 الصلاحية الجديدة: "..formatDate(EXPIRE_DATE))
        else
            -- بعد التجديد مرة، يقفل نهائي
            os.remove(ipFile)
            os.remove(saveFile)
            gg.alert("❌ انتهت صلاحية الكود! لازم تدخل كود جديد.")
            os.exit()
        end
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
            '🚫 إيقاف نسبة الحظ'
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
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedShoot = gg.getResults(10)
            gg.editAll("1066399999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("✅ تم تفعيل التسديد القوي")

        elseif menu == 2 then
            if #savedShoot > 0 then
                gg.setValues(savedShoot)
                gg.toast("❌ رجع التسديد القوي للأصل")
            else
                gg.toast("⚠️ مفيش قيم محفوظة للتسديد!")
            end

        elseif menu == 3 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedPossession = gg.getResults(10)
            gg.editAll("1063199999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("⚽✅ تم تفعيل الاستحواذ 100%")

        elseif menu == 4 then
            if #savedPossession > 0 then
                gg.setValues(savedPossession)
                gg.toast("♻️ رجع الاستحواذ الأصلي")
            else
                gg.toast("⚠️ مفيش قيم محفوظة للاستحواذ!")
            end

        elseif menu == 5 then
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_FLOAT)
            gg.searchNumber("1065353216;720;486;30000;1001:17", gg.TYPE_DWORD)
            gg.refineNumber("1065353216", gg.TYPE_DWORD)
            savedLuck = gg.getResults(10)
            gg.editAll("1066999999", gg.TYPE_DWORD)
            gg.clearResults()
            gg.toast("🍀✅ تم تفعيل نسبة الحظ!")

        elseif menu == 6 then
            if #savedLuck > 0 then
                gg.setValues(savedLuck)
                gg.toast("🚫 رجعت قيم الحظ للأصل ✅")
            else
                gg.toast("⚠️ مفيش قيم محفوظة للحظ!")
            end

        elseif (isUltraVIP or isUltraMaster) and menu == 7 then
            gg.setSpeed(2.0)
            gg.alert("⏩ الوقت مسرع ×2")

        elseif (isUltraVIP or isUltraMaster) and menu == 8 then
            gg.setSpeed(1.0)
            gg.alert("⏸ تم إيقاف سرعة الوقت")

        elseif (isUltraVIP or isUltraMaster) and menu == 9 then
            gg.alert("⏱️ تم تفعيل تايمر 6:15 دقيقة...")
            gg.sleep(375000)
            gg.alert("🚀 تايمر انتهى! تفعيل السرعة ×10")
            gg.setSpeed(10.0)

        elseif (isUltraVIP or isUltraMaster) and menu == 10 then
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

        elseif ((not isUltraVIP and not isUltraMaster) and menu == 7) or ((isUltraVIP or isUltraMaster) and menu == 11) then
            os.remove(ipFile)
            os.remove(saveFile)
            os.remove(renewFlagFile)
            gg.alert("🗑 تم مسح الكود – هتحتاج تدخله تاني في التشغيل الجاي.")
            os.exit()

        elseif ((not isUltraVIP and not isUltraMaster) and menu == 8) or ((isUltraVIP or isUltraMaster) and menu == 12) then
            gg.toast("👋 تم الخروج من الأداة.")
            os.exit()
        end
    end
    gg.sleep(400)
end
