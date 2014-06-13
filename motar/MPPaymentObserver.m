//
//  MPPaymentObserver.m
//  motar
//
//  Created by Varun Santhanam on 4/21/14.
//  Copyright (c) 2014 Varun Santhanam. All rights reserved.
//

#import "MPPaymentObserver.h"

@implementation MPPaymentObserver {
    
    UIAlertView *_failureError;
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    NSLog(@"%@", queue);
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                [self transactionFailed:transaction];
                break;
            
            case SKPaymentTransactionStatePurchased:
                [self transactionPurchased:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self transactionRestored:transaction];
                break;
                
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Attempting %@", transaction.payment.productIdentifier);
                break;
            default:
                break;
                
        }
        
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        NSLog(@"Removed %@", transaction.payment.productIdentifier);
        
    }
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
    NSLog(@"Restored Transactions");
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    if (error != NULL) {
        
        NSLog(@"Failed to restore transactions with error: %@", error);
        
    }
    
}

- (void)transactionFailed:(SKPaymentTransaction *)transaction {
    
    NSLog(@"Failed to complete transaction %@", transaction.payment.productIdentifier);
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    self->_failureError = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"Your transaction did not go through"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FailedNoAds" object:nil];
    [self->_failureError show];
    
}

- (void)transactionPurchased:(SKPaymentTransaction *)transaction {
    
    if ([transaction.payment.productIdentifier isEqualToString:@"com.varunsanthanam.motar.noads"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PurchasedNoAds" object:nil];
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)transactionRestored:(SKPaymentTransaction *)transaction {
    
    if ([transaction.payment.productIdentifier isEqualToString:@"com.varunsanthanam.motar.noads"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PurchasedNoAds" object:nil];
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

@end
