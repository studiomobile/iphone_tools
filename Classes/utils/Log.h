//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#ifdef DEBUG_LOG
    #define DEBUG(f, ...) NSLog(f, ##__VA_ARGS__)
#else
    #define DEBUG(f, ...) 
#endif


