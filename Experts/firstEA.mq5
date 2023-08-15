#property copyright "Amir Nabizadeh"
#property link      ""
#property version   "1.00"
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Variables                                                        |
//+------------------------------------------------------------------+
input int openHour;
input int closeHour;
bool isTradeOpen = false;
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
    //check user input
    if(openHour==closeHour){
        Alert("oops. open and close are same.");
        return(INIT_PARAMETERS_INCORRECT);
    }

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
    // get current time
    MqlDateTime timeNow;
    TimeToStruct(TimeCurrent(),timeNow);
    
    // check for trade open
    if(openHour==timeNow.hour && !isTradeOpen){
        
        // position open
        trade.PositionOpen(_Symbol, ORDER_TYPE_BUY,0.01,SymbolInfoDouble(_Symbol, SYMBOL_ASK),0,0);
        Print("Position Open: "+TimeToString(TimeCurrent()));

        // set position open flag
        isTradeOpen = true;
    }

    // check for trade close
    if(closeHour==timeNow.hour && isTradeOpen){

        // position open
        trade.PositionClose(_Symbol);
        Print("Position Close: "+TimeToString(TimeCurrent()));

        // set position open flag
        isTradeOpen = false;
    }
}
//+------------------------------------------------------------------+
