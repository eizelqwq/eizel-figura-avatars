function uwuify(text)
    local emoticons = {"OwO", "UwU", ":3", "owo", "uwu", "x3", "X3", ">.<", ">w<"}

    local function replaceRsAndLs(str)
        str = string.gsub(str, "[RL]", "W")
        str = string.gsub(str, "[rl]", "w")
        return str
    end

    local function addStutter(str)
        return string.gsub(str, "(%a)(%w*)", function(firstLetter, restOfWord)
            local rand = math.random()
            if rand < 0.6 then
                return firstLetter .. "-" .. firstLetter .. restOfWord
            elseif rand < 0.65 then
                return firstLetter .. "-" .. firstLetter .. "-" .. firstLetter .. restOfWord
            else
                return firstLetter .. restOfWord
            end
        end)
    end

    local function addEmoticonsAtEnd(str)
        return str .. " " .. emoticons[math.random(#emoticons)]
    end

    text = replaceRsAndLs(text)
    text = addStutter(text)
    text = addEmoticonsAtEnd(text)

    return text
end

function events.chat_send_message(msg)
    if msg:find("/") then return msg end
    if not toggle then return msg end
    return uwuify(msg)
end