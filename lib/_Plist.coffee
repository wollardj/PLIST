entities = new XmlEntities()

class _Plist

    @parse: (xmlString)->
        plist = new PlistParser xmlString, {
                'processors': {
                    'string': (value)->
                        value.trim()
                    'real': (value)->
                        Number(value)
                    'data': (value)->
                        console.warn "PLIST doesn't handle `data` values properly. Sorry :("
                        value
                }
            }

        plist.parse()


    @stringify: (jsObject)->
        '<?xml version="1.0" encoding="UTF-8"?>\n' +
            '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" ' +
            '"http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n' +
            '<plist version="1.0">\n' +
            @_stringify(null, jsObject, '\t') +
            '</plist>\n'


    @_stringify: (key, val, prefix = '\t')->

        if _.isBoolean val
            @_stringifyBoolean key, val, prefix

        else if _.isDate val
            @_stringifyDate key, val, prefix

        else if _.isNumber(val) and Math.round(val) is val and not /e/.test(val)
            @_stringifyInteger key, val, prefix

        else if _.isNumber(val)
            @_stringifyReal key, val, prefix

        else if _.isString val
            @_stringifyString key, val, prefix

        else if _.isArray val
            @_stringifyArray key, val, prefix

        else if _.isObject val
            @_stringifyDict key, val, prefix

        else
            @_stringifyData key, val, prefix


    @_stringifyFormatKey: (key, prefix)->
        if key and key.length isnt 0
            prefix + '<key>' + entities.encodeNonUTF(key) + '</key>\n'
        else
            ''

    @_stringifyDict: (key, val, prefix = '\t')->
        out = @_stringifyFormatKey(key, prefix) + prefix + '<dict>\n'

        for own k, v of val
            out += @_stringify k, v, prefix + '\t'
        out + prefix + '</dict>\n'


    @_stringifyArray: (key, val, prefix = '\t')->
        out = @_stringifyFormatKey(key, prefix) + prefix + '<array>\n'

        for own k, v of val
            out += @_stringify null, v, prefix + '\t'
        out + prefix + '</array>\n'



    @_stringifyString: (key, val, prefix)->
        out = @_stringifyFormatKey(key, prefix) + prefix + '<string'
        if val and val.length isnt 0
            out + '>' + entities.encodeNonUTF(val) + '</string>\n'
        else
            out + '/>\n'

    @_stringifyBoolean: (key, val, prefix)->
        if val is true
            k = 'true'
        k ?= 'false'

        @_stringifyFormatKey(key, prefix) +
            prefix + '<' + k + '/>\n'


    @_stringifyDate: (key, val, prefix)->
        # we have to save the date in Zulu time, but plists don't accept
        # sub-second precision, so we have to remove that information
        @_stringifyFormatKey(key, prefix) + prefix +
            '<date>' +
                val.toISOString().replace(/\.[0-9]*Z$/, 'Z') + '</date>\n'


    @_stringifyInteger: (key, val, prefix)->
        @_stringifyFormatKey(key, prefix) + prefix +
            '<integer>' + val + '</integer>\n'

    @_stringifyReal: (key, val, prefix)->
        @_stringifyFormatKey(key, prefix) + prefix +
            '<real>' + val.toString().replace('e', 'E') + '</real>\n'


    @_stringifyData: (key, val, prefix)->
        console.warn "PLIST doesn't handle `data` values properly. Sorry :("
        @_stringifyFormatKey(key, prefix) + prefix +
            '<data>' + val + '</data>\n'

@_Plist = _Plist
