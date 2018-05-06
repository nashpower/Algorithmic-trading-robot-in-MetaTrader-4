//+------------------------------------------------------------------+
//|                                                    SimpleSys.mq4 |
//|                                                        nashpower |
//|                                     https://github.com/nashpower |
//+------------------------------------------------------------------+
#property copyright "nashpower"
#property link      "https://github.com/nashpower"
#property version   "1.00"
#property strict
extern int     StartHour      = 9; 
extern int     TakeProfit     = 40;
extern int     StopLoss       = 40;
extern double  Lots           = 1;
extern int     MA_Period      = 100;
 
void OnTick()
{
   static bool IsFirstTick = true;
   static int  ticket = 0;
   
   double ma = iMA(Symbol(), Period(), MA_Period, 0, 0, 0, 1);
   
   if(Hour() == StartHour)
   {
      if(IsFirstTick == true)
      {
         IsFirstTick = false;
      
         bool res;
         res = OrderSelect(ticket, SELECT_BY_TICKET);
         if(res == true)
         {
            if(OrderCloseTime() == 0)
            {
               bool res2;
               res2 = OrderClose(ticket, Lots, OrderClosePrice(), 10);
               
               if(res2 == false)
               {
                  Alert("Error Closing Order #", ticket);
               }
            } 
         }
      
         if(Open[0] < Open[StartHour])
         {
            //check ma
            if(Close[1] < ma)
            {
               ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid-StopLoss*Point, Bid+TakeProfit*Point, "Set by SimpleSystem");
               if(ticket < 0)
               {
                  Alert("Error Sending Order!");
               }
            }
         }
         else
         {
            //check ma
            if(Close[1] > ma)
            {
               ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask+StopLoss*Point, Ask-TakeProfit*Point, "Set by SimpleSystem");
               if(ticket < 0)
               {
                  Alert("Error Sending Order!");
               }
            }
         }
 
      }
   }
   else
   {
      IsFirstTick = true;
   }
 
}