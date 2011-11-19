--- 
author: chris
image:
  url: http://farm1.static.flickr.com/67/170500174_d15d6c5541_m_d.jpg
  title: A happy application in the cloud. Photo by Timothy K. Hamilton.
  alt: A happy application in the cloud.
layout: post
title: Optimizing hardware costs for Amazon EC2
tags: 
- technology
---

A happy application in the cloud. Photo by Timothy K. Hamilton.

Flatterline believes heavily in the power of [cloud computing](http://en.wikipedia.org/wiki/Cloud_computing). Dynamically allocated hardware on a pay-for-what-you-need basis has tremendous advantages when it comes to helping clients manage and provision their clusters. The main advantage of cloud computing is dynamically growing, or shrinking, hardware as the needs of the application change.

Because of the dynamic nature of cloud computing, we don't need a guaranteed answer on hardware requirements up front. However, a client may want a ballpark figure in order to set aside the right amount of budget or let investors know the estimated operational cost. You could crunch the numbers yourself, but why would you do that when we've already automated the process for you?

## Determining optimal cost

We've constructed a very basic model for minimizing the cost of [Amazon EC2](http://aws.amazon.com/ec2/) hardware resources which satisfies a minimum number of [EC2 Compute Units](http://aws.amazon.com/ec2/instance-types/) and a given amount of RAM per process.

The technique uses [linear programming](http://en.wikipedia.org/wiki/Linear_programming) and the [GNU linear programming kit (GLPK)](http://en.wikipedia.org/wiki/GNU_Linear_Programming_Kit). **Note**: I'm a math geek that likes linear modeling, so if you're unfamiliar with either, I'd be happy to chat with you about them over lunch.

## Installation

First, install the GLPK. On Ubuntu execute the command

    sudo aptitude install glpk

on Mac OS X execute the command

    sudo port install glpk

Next, download the following gist as `cloud_cost.txt`.

<script src="http://gist.github.com/101809.js"></script>

## Computing the cost

The model requires the specification of two variables: total number of EC2 Compute Units and RAM. Both variables are specified at the bottom with `param unitsNeeded` and `param ramRequiredPerAppInstance` respectively. Change these params to reflect your particular situation. **Note**: A future article will explore capacity planning in more detail.

When you're ready, execute the solver using the following command:

    glpsol --model cloud_cost.txt --output result.txt

## Analyzing the results

The program generates the result into a file called `result.txt`. Assuming 500 EC2 Compute Units with 125MB of RAM per process, the file will look something like the following:

    Problem:  cloud_cost
    Rows:    7
    Columns:  5 (5 integer, 0 binary)
    Non-zeros: 15
    Status:   INTEGER OPTIMAL
    Objective: cost = 14400 (MINimum)
    
     1 InstanceQuantity[Small]
                        *              0             0
     2 InstanceQuantity[Large]
                        *              0             0
     3 InstanceQuantity[XLarge]
                        *              0             0
     4 InstanceQuantity[HCPULarge]
                        *              0             0
     5 InstanceQuantity[HCPUXLarge]
                        *             25             0

The objective function was cost, so the optimal arrangement of hardware needed to get that computational power costs $14,400/month. The second column of the hardware arrangement indicates the number of instance needed. In this case we need 25 high-CPU, extra large instances.

**Did you find this useful? Let us know in the comments!**
