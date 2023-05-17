local utf8_decode = {
    [128] = {
        [147] = '\150',
        [148] = '\151',
        [152] = '\145',
        [153] = '\146',
        [154] = '\130',
        [156] = '\147',
        [157] = '\148',
        [158] = '\132',
        [160] = '\134',
        [161] = '\135',
        [162] = '\149',
        [166] = '\133',
        [176] = '\137',
        [185] = '\139',
        [186] = '\155'
    },
    [130] = {[172] = '\136'},
    [132] = {[150] = '\185', [162] = '\153'},
    [194] = {
        [152] = '\152',
        [160] = '\160',
        [164] = '\164',
        [166] = '\166',
        [167] = '\167',
        [169] = '\169',
        [171] = '\171',
        [172] = '\172',
        [173] = '\173',
        [174] = '\174',
        [176] = '\176',
        [177] = '\177',
        [181] = '\181',
        [182] = '\182',
        [183] = '\183',
        [187] = '\187'
    },
    [208] = {
        [129] = '\168',
        [130] = '\128',
        [131] = '\129',
        [132] = '\170',
        [133] = '\189',
        [134] = '\178',
        [135] = '\175',
        [136] = '\163',
        [137] = '\138',
        [138] = '\140',
        [139] = '\142',
        [140] = '\141',
        [143] = '\143',
        [144] = '\192',
        [145] = '\193',
        [146] = '\194',
        [147] = '\195',
        [148] = '\196',
        [149] = '\197',
        [150] = '\198',
        [151] = '\199',
        [152] = '\200',
        [153] = '\201',
        [154] = '\202',
        [155] = '\203',
        [156] = '\204',
        [157] = '\205',
        [158] = '\206',
        [159] = '\207',
        [160] = '\208',
        [161] = '\209',
        [162] = '\210',
        [163] = '\211',
        [164] = '\212',
        [165] = '\213',
        [166] = '\214',
        [167] = '\215',
        [168] = '\216',
        [169] = '\217',
        [170] = '\218',
        [171] = '\219',
        [172] = '\220',
        [173] = '\221',
        [174] = '\222',
        [175] = '\223',
        [176] = '\224',
        [177] = '\225',
        [178] = '\226',
        [179] = '\227',
        [180] = '\228',
        [181] = '\229',
        [182] = '\230',
        [183] = '\231',
        [184] = '\232',
        [185] = '\233',
        [186] = '\234',
        [187] = '\235',
        [188] = '\236',
        [189] = '\237',
        [190] = '\238',
        [191] = '\239'
    },
    [209] = {
        [128] = '\240',
        [129] = '\241',
        [130] = '\242',
        [131] = '\243',
        [132] = '\244',
        [133] = '\245',
        [134] = '\246',
        [135] = '\247',
        [136] = '\248',
        [137] = '\249',
        [138] = '\250',
        [139] = '\251',
        [140] = '\252',
        [141] = '\253',
        [142] = '\254',
        [143] = '\255',
        [144] = '\161',
        [145] = '\184',
        [146] = '\144',
        [147] = '\131',
        [148] = '\186',
        [149] = '\190',
        [150] = '\179',
        [151] = '\191',
        [152] = '\188',
        [153] = '\154',
        [154] = '\156',
        [155] = '\158',
        [156] = '\157',
        [158] = '\162',
        [159] = '\159'
    },
    [210] = {[144] = '\165', [145] = '\180'}
}

local nmdc = {[36] = '$', [124] = '|'}

local function Utf8ToAnsiUnSave(s)
    local bad_char_count = 0
    local a, j, r, b = 0, 0, ''
    for i = 1, s and s:len() or 0 do
        b = s:byte(i)
        if b < 128 then
            if nmdc[b] then
                r = r .. nmdc[b]
            else
                r = r .. string.char(b)
            end
        elseif a == 2 then
            a, j = a - 1, b
        elseif a == 1 then
            a, r = a - 1, r .. utf8_decode[j][b]
        elseif b == 226 then
            a = 2
        elseif b == 194 or b == 208 or b == 209 or b == 210 then
            j, a = b, 1
        else
            -- r = r .. '_'
            r = r .. string.char(s:byte(i))
            bad_char_count = bad_char_count + 1
        end
    end

    if bad_char_count / s:len() > 0.2 then
        return s
    end

    return r
end

function Utf8ToAnsi(s)
    local status, ansi_s = pcall(Utf8ToAnsiUnSave, s);
    if status then return ansi_s end

    return s
end