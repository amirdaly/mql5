
#property copyright "Amir Nabizadeh"
#property link      ""
#property version   "1.00"
#include <Trade\Trade.mqh>

int OnInit()
  {
   CTrade trade;
   double ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   double bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
   //trade.PositionOpen(Symbol(),ORDER_TYPE_BUY,0.01,ask,ask-1000*Point(),ask+300*Point(),"mine");
   trade.Sell(0.01,Symbol(),bid,bid+20*Point(),bid-20*Point(),"noting");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+