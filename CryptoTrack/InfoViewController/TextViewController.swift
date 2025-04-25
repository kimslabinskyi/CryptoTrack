//
//  TextViewController.swift
//  CryptoTrack
//
//  Created by Kim on 23.04.2025.
//

import UIKit

class TextViewController: UIViewController {
    var indexPath: IndexPath?
    
    var sectionIndex: Int {
        return indexPath?.section ?? 0
    }
    
    var rowIndex: Int {
        return indexPath?.row ?? 0
    }
    
    let data = [""]

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        print("indexPath = \(String(describing: indexPath)), rowIndex = \(rowIndex)")
        
        if sectionIndex == 0 {
            switch rowIndex {
            case 0:
                textView.text = """
        Cryptocurrency trading is the buying and selling of cryptocurrencies on an exchange. It involves speculating on price movements of digital currencies like Bitcoin and Ethereum, with the goal of making a profit from these price fluctuations. Unlike traditional markets, cryptocurrency markets operate 24/7, creating virtually limitless trading opportunities.
        """
            case 1:
                textView.text = """
        Cryptocurrency markets operate through a decentralized digital currency network, functioning via peer-to-peer transaction checks rather than through a central server. All transactions are recorded on a blockchain – a shared digital ledger – through a process called 'mining'. These markets move according to supply and demand but remain relatively free from many economic and political concerns that affect traditional currencies.
        """
            case 2:
                textView.text = """
        Cryptocurrencies are notoriously volatile, experiencing significant price swings in short periods. This volatility can create both opportunities for profit and increased risk exposure. Before entering the market, it's essential to acknowledge and prepare for this inherent characteristic of crypto trading.
        """
            default:
                textView.text = ""
            }
        } else if sectionIndex == 1 {
            switch rowIndex {
            case 0:
                textView.text = """
        A cryptocurrency exchange is a digital platform that allows users to buy and sell cryptocurrencies. When selecting an exchange, consider factors like:
            • Security measures
            • Available trading pairs
            • Fee structures
            • User interface

        There are two main types of exchanges:
            • Centralized Exchanges (CEX): Managed by a central entity, offering user-friendly interfaces ideal for beginners.
            • Decentralized Exchanges (DEX): Operating through blockchain technology for peer-to-peer transactions without intermediaries.
        """
            case 1:
                textView.text = """
        After selecting an exchange, you'll need to:
            • Create an account by providing your email address and creating a strong password.
            • Complete identity verification procedures (KYC) required by most legitimate exchanges.
            • Enable two-factor authentication (2FA) for additional security.
            • Consider using unique passwords and secure email addresses specifically for your crypto activities.
        """
            case 2:
                textView.text = """
        Once your account is set up and secured, you'll need to deposit funds to begin trading:
            • Most exchanges support deposits in fiat currency (USD, EUR, etc.).
            • Connect your bank account, credit card, or use other supported payment methods.
            • Alternatively, if you already own cryptocurrency, you can transfer it from another wallet.
            • Be aware of any deposit fees or minimum deposit requirements.
        """
            default:
                textView.text = ""
            }
        } else if sectionIndex == 2 {
            switch rowIndex {
            case 0:
                textView.text = """
        Trading pairs show which currencies can be exchanged for one another on an exchange. For example:
            • BTC/USD allows you to buy or sell Bitcoin with US dollars.
            • ETH/BTC enables trading Ethereum for Bitcoin.
            • Crypto-to-fiat pairs (like BTC/USD) let you exchange cryptocurrencies for traditional currencies.
            • Crypto-to-crypto pairs (like ETH/BTC) allow trading between different cryptocurrencies.
        """
            case 1:
                textView.text = """
        When trading cryptocurrency, you'll primarily use two types of orders:
            • Market orders: Execute immediately at the current market price, prioritizing speed over price. These orders are filled at the best available price when the order is placed.
            • Limit orders: Allow you to specify the exact price at which you want to buy or sell. These orders only execute when the market reaches your specified price, giving you price control at the expense of immediate execution.
        """
            case 2:
                textView.text = """
        An order book is a collection of limit orders showing the prices at which traders are willing to buy or sell a cryptocurrency:
            • It displays the number of units bid on or offered at each price point.
            • The bid-ask spread is the difference between the lowest asking price and the highest bidding price.
            • Market orders cross this spread, effectively paying for immediate liquidity.
            • Large market orders may experience price slippage when they move through multiple price levels of the order book.
        """
            default:
                textView.text = ""
            }
        } else if sectionIndex == 3 {
            switch rowIndex {
            case 0:
                textView.text = """
        This strategy involves purchasing cryptocurrencies and holding them for an extended period:
            • Based on a belief in the long-term potential and value appreciation of chosen cryptocurrencies.
            • Requires less active management and trading knowledge.
            • Helps avoid short-term market volatility and emotional decision-making.
            • Known in crypto communities as "HODL" (Hold On for Dear Life).
        """
            case 1:
                textView.text = """
        With DCA, you invest a fixed amount of money into specific cryptocurrencies at regular intervals:
            • Reduces the impact of volatility by averaging your purchase price over time.
            • Removes the pressure of timing the market perfectly.
            • Creates a disciplined investment approach regardless of market conditions.
            • Works well for beginners who are unsure about market timing.
        """
            case 2:
                textView.text = """
        Day trading involves making multiple trades within a single day to capitalize on short-term price movements:
            • Requires significant time commitment and market monitoring.
            • Demands quick decision-making and deep market understanding.
            • Uses technical analysis tools and indicators to identify trading opportunities.
            • Carries higher risk and potential for both quick gains and losses.
        """
            default:
                textView.text = ""
            }
        } else if sectionIndex == 4 {
            switch rowIndex {
            case 0:
                textView.text = """
        Successful traders always establish risk management rules:
            • Determine what percentage of your capital you're willing to risk on a single trade (commonly 1-2%).
            • Use stop-loss orders to automatically exit positions when prices move against you.
            • Take profit orders can lock in gains when targets are reached.
            • Never invest more than you can afford to lose.
        """
            case 1:
                textView.text = """
        Protecting your cryptocurrency is critical:
            • Use hardware wallets for long-term storage of significant amounts.
            • Enable all available security features on exchange accounts.
            • Be vigilant about phishing attempts and suspicious links.
            • Regularly update passwords and security credentials.
            • Consider splitting assets between exchanges and private wallets.
        """
            case 2:
                textView.text = """
        The cryptocurrency market's volatility can trigger strong emotional reactions:
            • Develop and stick to a trading plan to avoid impulsive decisions.
            • Take breaks from trading during periods of high stress.
            • Document your trades and reasons for making them to learn from experience.
            • Avoid making decisions based on FOMO (Fear Of Missing Out) or market panic.
        """
            default:
                textView.text = ""
            }
        } else if sectionIndex == 5 {
            switch rowIndex {
            case 0:
                textView.text = """
        Technical analysis uses historical price data to predict future movements:
            • Chart patterns provide visual representation of price movements.
            • Common indicators include Moving Averages, Relative Strength Index (RSI), and MACD.
            • Support and resistance levels help identify potential price reversal points.
            • Volume indicators show the strength behind price movements.
        """
            case 1:
                textView.text = """
        Market sentiment significantly impacts cryptocurrency prices:
            • News events can cause rapid price changes.
            • Social media sentiment often influences crypto markets.
            • Market cycles typically move between extreme fear and greed.
            • Learning to identify prevailing sentiment can help with timing trades.
        """
            case 2:
                textView.text = """
        Spreading investment across different cryptocurrencies can reduce risk:
            • Research fundamentals of various projects before investing.
            • Consider allocating capital based on market capitalization and project maturity.
            • Some traders include both established coins (Bitcoin, Ethereum) and newer altcoins.
            • Rebalance your portfolio periodically based on performance and changing market conditions.
        """
            default:
                textView.text = ""
            }
        } else {
            textView.text = ""
        }

    }

    


}
