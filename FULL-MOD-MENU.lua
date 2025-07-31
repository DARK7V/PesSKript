-- 🏷️ رقم نسخة السكربت
local SCRIPT_VERSION = "3.5"

-- 🔒 طلب كلمة السر + مفتاح VIP
password = gg.prompt({
    [1] = 'ادخل كلمه السر هنا 👇:',
    [2] = '🎟️ ادخل مفتاح VIP (اختياري):'
}, {}, {[1] = 'text', [2] = 'text'})

-- ✅ التحقق من كلمة السر
if not password or (password[1] ~= "VIP" and password[1] ~= "MASTER" and password[1] ~= "Loden") then
    gg.alert("❌ كلمة السر غلط! حاول مرة تانية.")
    os.exit()
end

-- 🎯 تحديد نوع الباسورد
local isMaster = (password[1] == "MASTER")
local isPro = (password[1] == "Loden")

if isMaster then
    gg.alert("✅ كلمة السر MASTER – الأداة شغالة بدون انتهاء 🔓")
elseif isPro then
    gg.alert("✅ كلمة السر Loden – الصلاحية 7 أيام ⏳")
else
    gg.alert("✅ كلمة السر VIP – الصلاحية 3 أيام ⏳")
end

gg.toast("✅ تم تفعيل الأداة!")

-----------------------------------------------------
-- 🔑 مفتاح VIP السري
-----------------------------------------------------
local vipKey = "VIP3"   -- 🔥 تقدر تغيّر المفتاح هنا
local isVIP = false
if password[2] == vipKey then
    isVIP = true
    gg.alert("🎉✅ تم تفعيل وضع VIP! \n✨ ظهرت لك مميزات إضافية.")
end

-----------------------------------------------------
-- 📂 ملفات التخزين
-----------------------------------------------------
local saveFile = "/storage/emulated/0/.gg_script_date.txt"
local versionFile = "/storage/emulated/0/.gg_script_version.txt"

-----------------------------------------------------
-- 🔧 ✨ خاصية إيقاف الهاك وقت التحديثات ✨
-----------------------------------------------------
local maintenanceMode = false   -- لو خليتها true = الهاك يتقفل

if maintenanceMode then
    os.remove(versionFile)
    gg.alert("⚠️ الهاك موقوف مؤقتًا للتحديثات 🔧\n🔄 حاول مرة أخرى بعد شوية.")
    os.exit()
end

-----------------------------------------------------
-- 📆 تحديد تاريخ بداية التشغيل
-----------------------------------------------------
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
if not isMaster then
    if isPro then
        EXPIRE_DATE = START_DATE + (7 * 24 * 60 * 60)
    else
        EXPIRE_DATE = START_DATE + (3 * 24 * 60 * 60)
    end
end

-----------------------------------------------------
-- 🗓️ دالة عرض تاريخ الانتهاء
-----------------------------------------------------
local function formatDate(timestamp)
    local date = os.date("*t", timestamp)
    return string.format("%02d/%02d/%04d", date.day, date.month, date.year)
end

if not isMaster then
    gg.alert("📅 صلاحية السكربت تنتهي يوم: " .. formatDate(EXPIRE_DATE))
end

-----------------------------------------------------
-- 🎯 وظائف VIP – تحكم الزمن
-----------------------------------------------------
function speedInstant(mode)
    if mode == "x2" then
        gg.setSpeed(2.0)
        gg.alert("⏩ الوقت مسرع الآن ×2")
    elseif mode == "pause" then
        gg.setSpeed(0.0)
        gg.alert("⏸ الوقت متوقف الآن")
    end
end

function activateTimer()
    gg.alert("⏱️ تم تفعيل تايمر 6:15 دقيقة...")
    gg.sleep(375000)  -- 6 دقائق و15 ثانية
    gg.alert("🚀 التايمر انتهى! سرعة ×10")
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
        }, nil, "👑 تحكم VIP في الزمن ⏳")

        local speeds = {0.25, 0.5, 1.0, 2.0, 3.0, 5.0, 10.0}
        if choice == nil or choice == 8 then break end
        gg.setSpeed(speeds[choice])
        gg.alert("⚡ تم ضبط السرعة: " .. speeds[choice] .. "x")
    end
end

-----------------------------------------------------
-- 📦 جداول التخزين
-----------------------------------------------------
local savedValues = {}
local savedPossession = {}
local savedLuck = {}

-----------------------------------------------------
-- 🎯 القائمة الرئيسية
-----------------------------------------------------
while true do
    local now = os.time()

    if not isMaster then
        if now > EXPIRE_DATE then
            gg.alert("⚠️ انتهت صلاحية السكربت!")
            os.exit()
        elseif (EXPIRE_DATE - now) < 86400 then
            gg.toast("⏳ السكربت هينتهي خلال 24 ساعة!")
        end
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
            '🚪 خروج'
        }

        -- ✅ لو VIP نضيف خيار التحكم في الزمن
        if isVIP then
            table.insert(menuItems, 1, '🌟 وضع تحكم الزمن (VIP)')
        end

        local menu = gg.choice(menuItems, nil, 'قائمة ادوات 𝙡𝙤𝙙𝙚𝙣_لــــــودن 🇮🇶 👑')
        if not menu then goto continue end

        -- ✅ لو VIP وتم اختيار أول خيار
        if isVIP and menu == 1 then
            local vipChoice = gg.choice({
                "⏩ تسريع ×2",
                "⏸ إيقاف الوقت",
                "⏱️ تايمر 6:15 دقيقة ➜ سرعة ×10",
                "⚙️ قائمة سرعات كاملة",
                "🔙 رجوع"
            }, nil, "🌟 قائمة VIP")

            if vipChoice == 1 then
                speedInstant("x2")
            elseif vipChoice == 2 then
                speedInstant("pause")
            elseif vipChoice == 3 then
                activateTimer()
            elseif vipChoice == 4 then
                speedMenu()
            end
            goto continue
        elseif isVIP then
            menu = menu - 1
        end

        -----------------------------------------------------
        -- ⚽ الخيارات العادية
        -----------------------------------------------------
        if menu == 1 then
            gg.toast("✅ تم تفعيل التسديد القوي")
        elseif menu == 2 then
            gg.toast("❌ تم إيقاف التسديد القوي!")
        elseif menu == 3 then
            gg.toast("⚽✅ تم تفعيل الاستحواذ 100%")
        elseif menu == 4 then
            gg.toast("♻️✅ رجع الاستحواذ الأصلي")
        elseif menu == 5 then
            gg.toast("🍀✅ تم تفعيل نسبة الحظ!")
        elseif menu == 6 then
            gg.toast("🚫 تم إيقاف نسبة الحظ ورجوع القيم الأصلية ✅")
        elseif menu == 7 then
            gg.toast("👋 تم الخروج من الأداة.")
            os.exit()
        end
    end
    ::continue::
    gg.sleep(400)
end
