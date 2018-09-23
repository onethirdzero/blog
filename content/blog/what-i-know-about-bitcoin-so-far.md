---
title: "What I Know About Bitcoin So Far"
date: 2017-12-10T21:59:53-08:00
draft: false
---

I had heard about Bitcoin before, but didn't come across an interesting enough discussion to pique my interest in the technology. Last weekend though, I listened to [an episode of the Giant Robots Smashing Into Other Giant Robots podcast on blockchains](http://giantrobots.fm/250) which got me into some light reading on the matter.

Then, sometime during the week, Bitcoin hit $18k. That got my attention.

I started to devour every article I could find that would help me understand how the whole thing worked. I joined a cryptocurrency Slack channel at work. I pushed my usual list of podcasts back and started listening to ones on blockchains. It's all I think about now.

My understanding of how things work is still a little fuzzy, but I'm hoping to clear that up in the next week.

There are 2 main concepts that I see as important: the blockchain and the cryptocurrency.

## The blockchain

The blockchain is a distributed public ledger. Every node in the network has a copy of it. As the blockchain grows, so does each local copy on each node.

Every 10 minutes, a bunch of new entries into the ledger are committed as a new 'batch', which we call a block. These entries could be about anything, but in Bitcoin's case they record transactions.

Each node in the network helps create this block by contributing clock cycles. This is how work is done in the blockchain.

This work involves solving a math problem that gets harder with each block that is created. The work done is prohibitively intensive, which deters hackers from altering the blockchain.

Part of the reason for this is that in case of a fork in the block chain, the network will always choose the longer branch. If there's a tie, the network will just wait until there is an obvious answer.

So unless the hacker is able to keep ahead of the original branch, his branch will be abandoned eventually. As the combined computing power of the network grows, it becomes increasingly futile for anyone to even attempt an attack.

## The cryptocurrency

As a reward for doing work, bitcoins are released upon creation of each block, which is given to the node that solved the math problem first. This is where cryptocurrency comes from.

Note that the creation of blocks is independent of the transactions that occur throughout the network. That is, blocks don't need to be created just so that transactions can go through. New transactions just won't be committed to the blockchain right away.

Mining is the term given to the creation of blocks for bitcoin. This was misleading for me at first because the term implies that the work done is solely for the purpose of obtaining bitcoin, and not extending the blockchain.

Think of the cryptocurrency as just a token for now. It's just a symbol of utility. If we don't associate any monetary value with it, all it can be seen as is a medal of sorts for contributing to the growth of the ledger.

However, Bitcoin has all the characteristics of money. Bitcoin is uniform, durable, fungible, divisible, portable, and scarce. What better way to evaluate its utility than to assign a dollar value to it?

## To be continuted

One of the implications of Bitcoin I've heard about - one most commonly brought up by the news - is that Bitcoin could potentially replace fiat money. There are a few ways to get to that conclusion, but I don't feel well-versed enough to write about it yet.

So I'll leave this here for now, as proof-of-work of my foray into the world of cryptocurrencies.
