---
title: "Little-endian and Big-endian"
date: 2017-11-19T12:42:10-08:00
draft: false
---

I was watching the [prequel series](https://hero.handmade.network/episode/intro-to-c/day4) to Casey Muratori's excellent [Handmade Hero](https://handmadehero.org) last weekend and there was a small segment about endianness. I had heard about this in passing before, but [the Wikipedia article](https://en.wikipedia.org/wiki/Endianness) was too dry for me to tackle at the time.

Basically, endianness refers to how bytes for numerical values are formatted in memory.

Casey explained it in very simple terms: an architecture is little-endian if the lower order bit comes first in memory. It's big-endian if it's vice versa.

## Example

Say that we have a number `511` that we want to store in memory. Let's assume that each address in our memory holds a value that is a byte (8-bits) large.

To store `511`, we'll need `2` bytes: `1` byte to hold `255` and another to hold `256`.

```
255 + 256 = 511
```

Let's say that we store that number at contiguous addresses: `0x9000` and `0x9001`. If our architecture is little-endian, the memory will look like this:

|Address|Binary|Decimal|
|---|---|---|
|`0x9000`|`11111111`|`255`|
|`0x9001`|`00000001`|`256`|

In big-endian architecture, it will look like this:

|Address|Binary|Decimal|
|---|---|---|
|`0x9000`|`00000001`|`256`|
|`0x9001`|`11111111`|`255`|

## What does this mean for me?

This is only a problem when a binary created on a certain endianness is used on a machine with conflicting endianness, because the program will expect its native endianness when manipulating memory.

For the most part, most machines nowadays are on little-endian architecture because of the pervalence of Intel processors (x86, x64) and ARM chips, so endianness doesn't really affect us.

Interestingly, big-endian is more common in networking, which is why it is also known as network byte order.
