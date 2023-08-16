//+------------------------------------------------------------------+
//|                                                          buy.mq5 |
//|                                                   Amir Nabizadeh |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Amir Nabizadeh"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
input double TakeProfitPips = 200;  // Desired profit in pips
int OnInit()
  {
   return 0;
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

    double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double stopLossPrice = currentPrice - (TakeProfitPips * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
    double takeProfitPrice = currentPrice + (TakeProfitPips * SymbolInfoDouble(_Symbol, SYMBOL_POINT));

    CTrade trade;
    ulong ticket = trade.PositionOpen(_Symbol,ORDER_TYPE_BUY, 1.0, currentPrice, stopLossPrice,takeProfitPrice, "Buy order" );
    if (ticket > 0)
    {
        Print("Buy order opened successfully at price: ", currentPrice);
        while (!IsTradePositionClosed(ticket))
            Sleep(100);
        Print("Buy order closed with a profit of ", TakeProfitPips, " pips");
    }
    else
    {
        Print("Error opening buy order. Error code: ", trade.ResultRetcode());
    }
}


bool IsTradePositionClosed(ulong ticket)
{
    CTrade trade;
    return trade.PositionClose(ticket);
}