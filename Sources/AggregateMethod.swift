//
//  AggregateMethod.swift
//  edf2csv
//
//  Created by p-x9 on 2025/02/12
//  
//
import ArgumentParser

enum AggregateMethod: String, ExpressibleByArgument {
    case mean
    case mode
    case min
    case max
}
