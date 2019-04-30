//
//  RXPlayground.swift
//  CombustionConsumer
//
//  Created by Jonathan Freitas on 07/12/18.
//  Copyright © 2018 Jonathan Freitas. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RXPlayground {
    func play(){
        print("----- BASICS -----")
        // MARK: - Basics
        let bag = DisposeBag()
        let observable = Observable.just("Hello RX!")
        let subscription = observable.subscribe (onNext: {
            print($0)
        })
        subscription.disposed(by: bag)
        // ---------------
        print("----- PUBLISH SUBJECT -----")
        // MARK: - Publish Subject
        let publishSubject = PublishSubject<String>()
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("World")
        
        _ = publishSubject.subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("Again")
        
        _ = publishSubject.subscribe(onNext: {
            print(#line, $0)
        })
        publishSubject.onNext("Both subscriptions received this message.")
        // -------------------------
        print("----- MAP -----")
        // MARK: - Map
        Observable<Int>.of(1, 2, 3, 4).map { value in
            return value * 10
            }.subscribe(onNext:{
                print($0)
            })
        // -----------
        print("----- FLAT MAP -----")
        // MARK: - FlatMap
        let sequence1 = Observable<Int>.of(1, 2)
        let sequence2 = Observable<Int>.of(1, 2)
        let sequenceOfSequences = Observable.of(sequence1, sequence2)
        sequenceOfSequences.flatMap{ return $0 }.subscribe(onNext: {
            print($0)
        })
        // ---------------
        print("----- SCAN -----")
        // MARK: - Scan
        Observable.of(1, 2, 3, 4, 5).scan(0) { seed, value in
            return seed + value
            }.subscribe(onNext:{
                print($0)
            })
        // ------------
        print("----- BUFFER -----")
        // MARK: - Buffer
//        let SequenceThatEmitsWithDifferentIntervals = Observable.of(1, 2, 3, 4, 5, 6, 7)
//        SequenceThatEmitsWithDifferentIntervals
//            .buffer(timeSpan: 150, count: 3, scheduler: s)
//            .subscribe(onNext: {
//            print($0)
//        })
        // --------------
        print("----- FILTER -----")
        // MARK: - Filter
        Observable.of(2, 30, 22, 5, 60, 1).filter{$0 > 10}.subscribe(onNext: {
            print($0)
        })
        // --------------
        print("----- DISTINCT UNTIL CHANGED -----")
        //MARK: - Distinct Until Changed
        Observable.of(1, 2, 2, 1, 3).distinctUntilChanged().subscribe(onNext: {
            print($0)
        })
        // -----------------------------
        print("----- START WITH -----")
        // MARK: - Start With
        Observable.of(2, 3).startWith(1).subscribe(onNext: {
            print($0)
        })
        // ------------------
        print("----- MERGE -----")
        // MARK: - Merge
        let publish1 = PublishSubject<Int>()
        let publish2 = PublishSubject<Int>()
        Observable.of(publish1, publish2).merge().subscribe(onNext: {
            print($0)
        })
        publish1.onNext(20)
        publish1.onNext(40)
        publish1.onNext(60)
        publish2.onNext(1)
        publish1.onNext(80)
        publish2.onNext(2)
        publish1.onNext(100)
        // -------------
        print("----- Zip -----")
        // MARK: - Zip
        let a = Observable.of(1, 2, 3, 4, 5)
        let b = Observable.of("a", "b", "c", "d")
        Observable.zip(a, b){ return ($0, $1) }.subscribe {
            print($0)
        }
        // -----------
        print("----- SIDE EFFECTS -----")
        // MARK: - Side Effects
        Observable.of(1, 2, 3, 4, 5).do(onNext: {
            print($0)
        })
        // --------------------
        print("----- SCHEDULERS -----")
        // MARK: - Schedulers
        let publish3 = PublishSubject<Int>()
        let publish4 = PublishSubject<Int>()
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        Observable.of(publish3, publish4).observeOn(concurrentScheduler).merge().subscribeOn(MainScheduler()).subscribe(onNext: {
            print($0)
        })
        publish3.onNext(20)
        publish3.onNext(80)
        // ------------------
    }
}
