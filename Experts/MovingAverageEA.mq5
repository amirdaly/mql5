#property copyright "Amir Nabizadeh"
#property link      ""
#property version   "1.00"
#include <Trade\Trade.mqh>
//+------------------------------------------------------------------+
//| Input Variables                                                  |
//+------------------------------------------------------------------+
input int InpFastPeriod = 14;     // fast period
input int InpSlowPeriod = 21;     // slow period
input int InpStopLoss = 100;      // stop loss in point
input int IntTakeProfit = 300;    // take profit in point

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
int fastHandle;
int slowHandle;
double fastBuffer[];
double slowBuffer[];
CTrade trade;
datetime openTimeBuy = 0;
datetime openTimeSell = 0;
int winCount = 0;
int lossCount = 0;




//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){

   // check user input
   if(InpFastPeriod <= 0){
      Alert("Fast Period <+ 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   if(InpSlowPeriod <= 0){
      Alert("Slow Period <+ 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   if(InpFastPeriod >= InpSlowPeriod){
      Alert("Fast Period >= Slow Period");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   // create handles
   fastHandle = iMA(_Symbol,PERIOD_CURRENT,InpFastPeriod,0,MODE_SMA,PRICE_CLOSE);
   if(fastHandle == INVALID_HANDLE){
      Alert("Failed to create handle!");
      return(INIT_FAILED);
   }
   slowHandle = iMA(_Symbol, PERIOD_CURRENT, InpSlowPeriod, 0, MODE_SMA,PRICE_CLOSE);
   if(slowHandle == INVALID_HANDLE){
      Alert("Failed to create handle");
      return(INIT_FAILED);
   }

   ArraySetAsSeries(fastBuffer,true);
   ArraySetAsSeries(slowBuffer,true);

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   if(fastHandle != INVALID_HANDLE) { IndicatorRelease(fastHandle);}
   if(slowHandle != INVALID_HANDLE) { IndicatorRelease(slowHandle);}

   double totalTrades = winCount + lossCount;
   double winRate = (winCount / totalTrades) * 100.0;

   Print("Total Trades: ", totalTrades);
   Print("Winning Trades: ", winCount);
   Print("Losing Trades: ", lossCount);
   Print("Win Rate: ", winRate, "%");

}
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){

   // get indicator values
   int values = CopyBuffer(fastHandle,0,0,2,fastBuffer);
   if(values != 2){
      Print("Not enough data for fast moving average");
      return;
   }
   values = CopyBuffer(slowHandle,0,0,2,slowBuffer);
   if(values != 2){
      Print("Not enough data for slow moving average");
      return;
   }

   // check for cross buy
   if(fastBuffer[1] <= slowBuffer[1] && fastBuffer[0] > slowBuffer[0] && openTimeBuy != iTime(_Symbol,PERIOD_CURRENT,0)){
      openTimeBuy = iTime(_Symbol,PERIOD_CURRENT,0);

      double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double spread = ask - bid;
      double buySL = ask - spread - ( InpStopLoss * SymbolInfoDouble(_Symbol,SYMBOL_POINT));
      double buyTP = ask + spread + ( IntTakeProfit * SymbolInfoDouble(_Symbol,SYMBOL_POINT));

      trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,0.05,ask,buySL,buyTP,"Cros EA");
   }
   // check for cross sell
   if(fastBuffer[1] >= slowBuffer[1] && fastBuffer[0] < slowBuffer[0] && openTimeSell != iTime(_Symbol,PERIOD_CURRENT,0)){
      openTimeSell = iTime(_Symbol,PERIOD_CURRENT,0);

      double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double spread = ask - bid;
      double sellSL = bid + spread + ( InpStopLoss * SymbolInfoDouble(_Symbol,SYMBOL_POINT));
      double sellTP = bid - spread - ( IntTakeProfit * SymbolInfoDouble(_Symbol,SYMBOL_POINT));

      trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,0.05,bid,sellSL,sellTP,"Cros EA");
   
   }

}
//+------------------------------------------------------------------+
