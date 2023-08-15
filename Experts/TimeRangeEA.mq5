#property copyright "Amir Nabizadeh"
#property link      ""
#property version   "1.00"
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input long InpMagicNumber = 11111;  // magic number
input double InpLots = 0.01;        // lot size
input int InpRangeStart = 600;      // range start time in minutes
input int InpRangeDuration = 120;   // range duration in minutes
input int InpRangeClose = 1200;     // range close time in minutes

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
struct RANGE_STRUCT{
    datetime start_time;        // start of the range
    datetime end_time;          // end of the range
    datetime close_time;        // close time
    double high;                // high of the range
    double low;                 // low of the range
    bool f_entry;               // flag if we are inside the range
    bool f_high_breakout;       // flag if a high breakout occurred
    bool f_low_breakout;        // flag if a low breakout occurred

    RANGE_STRUCT() : start_time(0), end_time(0), close_time(0), high(0), low(99999), f_entry(false), f_high_breakout(false), f_low_breakout(0) {};
};

RANGE_STRUCT range;
MqlTick prevTick, lastTick;
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){

    // check if inputs are wrong
    if(InpMagicNumber <= 0){
        Alert("Magic number <= 0 ");
        return(INIT_PARAMETERS_INCORRECT);
    }
    if(InpLots <= 0 || InpLots > 1){
        Alert("Lots <= 0 or >1");
        return(INIT_PARAMETERS_INCORRECT);
    }
    if(InpRangeStart <= 0 || InpRangeStart >= 1440){
        Alert("Range start <= 0 or >= 1440");
        return(INIT_PARAMETERS_INCORRECT);
    }
    if(InpRangeDuration <= 0 || InpRangeDuration >= 1440 ){
        Alert("range duration <= 0 or >= 1440");
        return(INIT_PARAMETERS_INCORRECT);
    }
    if(InpRangeClose <= 0 || InpRangeClose >= 1440){
        Alert("Range close <= 0 or >= 1440");
        return(INIT_PARAMETERS_INCORRECT);
    }

    // calculated new range if input changed
    if(_UninitReason == REASON_PARAMETERS) { // no position open ++++++++++++
        CalculateRange();
    }
    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
    // delete objects
    ObjectsDeleteAll(NULL,"range");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   // Get current tick
   prevTick = lastTick;
   SymbolInfoTick(_Symbol, lastTick);

   // calculate new range
   if((InpRangeClose >= 0 && lastTick.time >= range.close_time)                         // close time reached
        || (range.f_high_breakout && range.f_low_breakout)                              // both breakout flags are true
        || range.end_time == 0                                                          // range not clculated yet                              
        || (range.end_time != 0 && lastTick.time > range.end_time && !range.f_entry)) { // there was a range calculated but no tick inside
            
        CalculateRange();
    }
}
//+------------------------------------------------------------------+

// calculate a new range
void CalculateRange(){
    // reset range variables
    range.start_time = 0;
    range.end_time = 0;
    range.close_time = 0;
    range.f_entry = false;
    range.f_high_breakout = false;
    range.f_low_breakout = false;

    // calculate range start time
    int time_cycle = 86400;
    range.start_time = (lastTick.time - (lastTick.time % time_cycle)) + InpRangeStart*60;
    for(int i=0; i<8; i++){
        MqlDateTime tmp;
        TimeToStruct(range.start_time,tmp);
        int dow = tmp.day_of_week;
        if(lastTick.time >= range.start_time || dow==6 || dow==0){
            range.start_time += time_cycle;
        }
    }

    // calculate range end time
    range.end_time = range.start_time + InpRangeDuration*60;
    for(int i=0; i<2; i++){
        MqlDateTime tmp;
        TimeToStruct(range.end_time,tmp);
        int dow = tmp.day_of_week;
        if(dow==6 || dow==0){
            range.end_time += time_cycle;
        }
    }

    // calculate range close 
    range.close_time = (range.end_time - (range.end_time % time_cycle)) + InpRangeClose*60;
    for(int i=0; i<8; i++){
        MqlDateTime tmp;
        TimeToStruct(range.close_time,tmp);
        int dow = tmp.day_of_week;
        if(range.close_time <= range.end_time || dow==6 || dow==0){
            range.close_time += time_cycle;
        }
    }

    // draw objects
    DrawObjects();
}

// draw objects
void DrawObjects(){
    // start time
    ObjectDelete(NULL,"range Start");
    if(range.start_time > 0 ){
        ObjectCreate(NULL, "range start", OBJ_VLINE, 0 , range.start_time,0);
        ObjectSetString(NULL, "range start",OBJPROP_TOOLTIP,"start of the range \n"+TimeToString(range.start_time,TIME_DATE|TIME_MINUTES));
        ObjectSetInteger(NULL,"range start", OBJPROP_COLOR,clrBrown);
        ObjectSetInteger(NULL,"range start", OBJPROP_WIDTH,2);
        ObjectSetInteger(NULL, "range start", OBJPROP_BACK,true);
    }

    // end time
    ObjectDelete(NULL,"range end");
    if(range.end_time > 0 ){
        ObjectCreate(NULL, "range end", OBJ_VLINE, 0 , range.end_time,0);
        ObjectSetString(NULL, "range end",OBJPROP_TOOLTIP,"end of the range \n"+TimeToString(range.end_time,TIME_DATE|TIME_MINUTES));
        ObjectSetInteger(NULL,"range end", OBJPROP_COLOR,clrBrown);
        ObjectSetInteger(NULL,"range end", OBJPROP_WIDTH,2);
        ObjectSetInteger(NULL, "range end", OBJPROP_BACK,true);
    }

    // close time
    ObjectDelete(NULL,"range close");
    if(range.end_time > 0 ){
        ObjectCreate(NULL, "range close", OBJ_VLINE, 0 , range.close_time,0);
        ObjectSetString(NULL, "range close",OBJPROP_TOOLTIP,"close of the range \n"+TimeToString(range.close_time,TIME_DATE|TIME_MINUTES));
        ObjectSetInteger(NULL,"range close", OBJPROP_COLOR,clrDarkGreen);
        ObjectSetInteger(NULL,"range close", OBJPROP_WIDTH,2);
        ObjectSetInteger(NULL, "range close", OBJPROP_BACK,true);
    }
}