#include <brl.mod/blitz.mod/blitz_string.h>
#include <brl.mod/blitz.mod/blitz_array.h>

// Mostly the same as the bbStringJoin function in blitz_string, except it also accepts a lower and upper bound as arguments
BBString *bbStringJoinSub( BBString *delimiter, BBArray *bitsarray, int lower, int upper ){
    if( bitsarray==&bbEmptyArray ){
        return &bbEmptyString;
    }else{        
        BBString **bits = (BBString**)BBARRAYDATA( bitsarray,1 );
        int size = 0;
        
        BBString **b; int i;
        
        b = bits;
        for( i=lower; i<upper; ++i ){
            BBString *bit=*b++;
            size += bit->length;
        }
        
        size += (upper - lower - 1) * delimiter->length;
        
        int delimsize = delimiter->length*sizeof(BBChar);
        BBString *str = bbStringNew( size );
        BBChar *strbuffer = str->buf;
        
        b = bits;
        for( i=lower; i<upper; ++i ){
            if(i){
                memcpy( strbuffer, delimiter->buf, delimsize );
                strbuffer += delimiter->length;
            }
            BBString *bit = *b++;
            memcpy( strbuffer, bit->buf, bit->length*sizeof(BBChar) );
            strbuffer += bit->length;
        }
        
        return str;
    }
}
