//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#ifdef DEBUG_LOG
    #define DEBUG(s) NSLog(s);
    #define DEBUGF(f, ...) NSLog(f, __VA_ARGS__);
#else
    #define DEBUG(s) 
    #define DEBUGF(f, ...) 
#endif

