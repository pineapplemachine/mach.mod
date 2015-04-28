superstrict
import bah.regex
import "../collect.mod/AList.bmx"

' example code

rem
local expressions:tokenregex[] = [ ..
    new tokenregex.init( "\s*" ).significant(0), ..
    new tokenregex.init( "\w+" ) ..
]
local tok:tokenizer = new tokenizer.init( expressions )
print tok.tokenize( "hello, world!" ).tostring()
endrem

type tokenizer
    field expressions:tokenregex[] = null
    field minsignificance% = 1
    field newlinestring$ = "~n"
    method init:tokenizer( expressions:tokenregex[], minsignificance% = 1, newlinestring$ = "~n" )
        self.expressions = expressions; self.minsignificance = minsignificance; self.newlinestring = newlinestring
        return self
    end method
    method tokenize:AList( data:object )
        if string( data )
            return tokenizestring( string( data ) )
        elseif tstream( data )
            return tokenizestream( tstream( data ) )
        else
            return null
        endif
    end method
    method tokenizestring:AList( data$ )
        local bytepos% = 0
        local linepos% = 1
        local linestartbyte% = 0
        local tokens:AList = new AList.init( data.length shr 4 )
        repeat
            local bestexpression:tokenregex = null
            local bestmatch:TRegexMatch = null
            local bestlength% = 0
            for local item:tokenregex = eachin expressions
                local match:TRegexMatch = item.find( data, bytepos )
                if match and match.substart() = bytepos
                    local matchlength% = match.subexp().length
                    if matchlength > bestlength
                        bestexpression = item
                        bestmatch = match
                        bestlength = matchlength
                    endif
                endif
            next
            if bestexpression
                local tokentext$ = bestmatch.subexp()
                local newlinecount% = countinstr( tokentext, newlinestring )
                if newlinecount
                    linepos :+ newlinecount
                    linestartbyte = bytepos + tokentext.findlast( newlinestring )
                endif
                if bestexpression.significance >= minsignificance
                    tokens.push( new token.init( tokentext, bestexpression, bestmatch, bytepos, linepos, bytepos - linestartbyte ) )
                endif
                bytepos :+ tokentext.length
            else
                local badtoken:token = new token.init( chr( data[ bytepos ] ), null, null, bytepos, linepos, bytepos - linestartbyte )
                bytepos :+ 1
                if badtoken.text = newlinestring 
                    linepos :+ 1
                    linestartbyte = bytepos
                endif
            endif
            if bytepos >= data.length return tokens
        forever
    end method
    method tokenizestream:AList( data:tstream )
        return tokenizestring( data.readstring( data.size() ) )
    end method
    function countinstr%( str$, sub$ )
        local count% = 0
        local position% = 0
        repeat
            local find% = str.find( sub, position )
            if find >= 0
                count :+ 1
                position = find + sub.length
            else
                return count
            endif
        forever
    end function
end type
type token
    field regex:tokenregex
    field match:TRegexMatch
    field text$ = null
    field capture$ = null
    field bytepos% = 0
    field linepos% = 0
    field columnpos% = 0
    method init:token( text$, regex:tokenregex, match:TRegexMatch, bpos%, lpos%, cpos% )
        self.text = text; self.regex = regex; self.match = match; bytepos = bpos; linepos = lpos; columnpos = cpos
        if match capture = match._subExp[0]
        return self
    end method
    method tostring$()
        return linepos+":"+columnpos+" ~q"+text+"~q"
    end method
end type
type tokenregex
    field regex:TRegex = null
    field lastmatch:TRegexMatch = null
    field lasttarget$ = null
    field lastpos% = 0
    field significance% = 1
    field label$
    method init:tokenregex( basis:object, label$ = null )
        if string( basis )
            regex = TRegex.create( string( basis ) )
        elseif TRegex( basis )
            regex = TRegex( basis )
        endif
        self.label = label
        assert regex
        return self
    end method
    method significant:tokenregex( value% )
        significance = value
    end method
    method find:TRegexMatch( target$, position% )
        if lasttarget = target and position >= lastpos and ((not lastmatch) or position <= lastmatch._substart[0])
            return lastmatch
        else
            assert regex
            lasttarget = target; lastpos = position; lastmatch = regex.find( target, position )
            return lastmatch
        endif
    end method
    method pattern$()
        assert regex
        return regex.searchpattern
    end method
end type


