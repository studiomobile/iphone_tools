//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#ifdef DEBUG_LOG
    // behavior of ## before __VA_ARGS__ is described here http://gcc.gnu.org/onlinedocs/cpp/Variadic-Macros.html
    #define SM_DEBUG(f, ...) NSLog(f, ##__VA_ARGS__)
#else
    #define SM_DEBUG(f, ...) 
#endif


