-- 🔒 طلب كلمة السر
password = gg.prompt({
    [1] = 'ادخل كلمه السر هنا 👇:',
}, {}, {[1] = 'text'})

-- ✅ التحقق من كلمة السر
if not password or (password[1] ~= "VIP" and password[1] ~= "MASTER" and password[1] ~= "PRO") then
    gg.alert("❌ كلمة السر غلط! حاول مرة تانية.")
    os.exit()
end

-- 🎯 تحديد نوع الباسورد
local isMaster = (password[1] == "MASTER")
local isPro = (password[1] == "PRO")

if isMaster then
    gg.alert("✅ كلمة السر MASTER – الأداة شغالة بدون انتهاء 🔓")
elseif isPro then
    gg.alert("✅ كلمة السر PRO – الصلاحية 7 أيام ⏳")
else
    gg.alert("✅ كلمة السر VIP – الصلاحية 3 أيام ⏳")
end

gg.toast("✅ تم تفعيل الأداة!")

-- 📂 مكان حفظ الملف
local saveFile = "/storage/emulated/0/.gg_script_date.txt"

-- 📆 تحديد تاريخ بداية التشغيل
local START_DATE

-- 🔍 لو الملف موجود نقرأ منه التاريخ
local file = io.open(saveFile, "r")
if file then
    START_DATE = tonumber(file:read("*a"))
    file:close()
else
    -- لو أول مرة نشغل السكربت، نكتب التاريخ الحالي
    START_DATE = os.time()
    file = io.open(saveFile, "w")
    file:write(START_DATE)
    file:close()
end

-- 📆 صلاحية حسب نوع الباسورد
local EXPIRE_DATE = nil
if not isMaster then
    if isPro then
        EXPIRE_DATE = START_DATE + (7 * 24 * 60 * 60)  -- PRO = 7 أيام
    else
        EXPIRE_DATE = START_DATE + (3 * 24 * 60 * 60)  -- VIP = 3 أيام
    end
end

-- 🗓️ دالة لعرض اليوم اللي بينتهي فيه
local function formatDate(timestamp)
    local date = os.date("*t", timestamp)
    return string.format("%02d/%02d/%04d", date.day, date.month, date.year)
end

if not isMaster then
    gg.alert("📅 صلاحية السكربت تنتهي يوم: " .. formatDate(EXPIRE_DATE))
end

-- 📦 جداول لحفظ القيم
local savedValues = {}
local savedPossession = {}
local savedLuck = {}

-- 🎯 حلقة السكربت الرئيسية
while true do
    local now = os.time()

    -- ✅ تحقق من انتهاء الصلاحية لو مش MASTER
    if not isMaster then
        if now > EXPIRE_DATE then
            gg.alert("⚠️ انتهت صلاحية السكربت!")
            os.exit()
        elseif (EXPIRE_DATE - now) < 86400 then
            gg.toast("⏳ السكربت هينتهي خلال 24 ساعة!")
        end
    end

    -- ✅ فتح القائمة لو ظهرت واجهة GG
    if gg.isVisible(true) then
        gg.setVisible(false)

        menu = gg.choice({
            '✅ تسديد قوي + حارس ضعيف',
            '❌ إيقاف التسديد القوي',
            '⚽ استحواذ 100%',
            '♻️ إيقاف الاستحواذ',
            '🍀 تفعيل نسبة الحظ',
            '🚫 إيقاف نسبة الحظ',
            '🚪 خروج'
        }, nil, '👑 قائمة الأدوات')

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
            gg.toast("✅ تم تفعيل التسديد القوي!")

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

        elseif menu == 7 then
            gg.toast("👋 تم الخروج من الأداة.")
            os.exit()
        end
    end

    gg.sleep(400)
end
