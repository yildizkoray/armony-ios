//
//  MockDispatchQueue.swift
//  Armony
//
//  Created by KORAY YILDIZ on 20.10.2025.
//

@testable import Armony
import Foundation

public final class MockDispatchQueue: DispatchQueueProtocol {

    var invokedSync = false
    var invokedSyncCount = 0
    var shouldInvokeSyncWork = false
    var stubbedSyncResult: Any!

    public func sync<T>(work: () throws -> T) rethrows -> T {
        invokedSync = true
        invokedSyncCount += 1
        if shouldInvokeSyncWork {
            _ = try? work()
        }
        return stubbedSyncResult as! T
    }

    var invokedAsync = false
    var invokedAsyncCount = 0
    var shouldInvokeAsyncWork = false

    public func async(execute work: @escaping @convention(block) () -> Void) {
        invokedAsync = true
        invokedAsyncCount += 1
        if shouldInvokeAsyncWork {
            work()
        }
    }

    var invokedAsyncAfter = false
    var invokedAsyncAfterCount = 0
    var invokedAsyncAfterParameters: (deadline: DispatchTime, Void)?
    var invokedAsyncAfterParametersList = [(deadline: DispatchTime, Void)]()
    var shouldInvokeAsyncAfterWork = false

    public func asyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
        invokedAsyncAfter = true
        invokedAsyncAfterCount += 1
        invokedAsyncAfterParameters = (deadline, ())
        invokedAsyncAfterParametersList.append((deadline, ()))
        if shouldInvokeAsyncAfterWork {
            work()
        }
    }

    var invokedAsyncAfterNow = false
    var invokedAsyncAfterNowCount = 0
    var invokedAsyncAfterNowParameters: (delay: Double, Void)?
    var invokedAsyncAfterNowParametersList = [(delay: Double, Void)]()
    var shouldInvokeAsyncAfterNowWork = false

    public func asyncAfterNow(delay: Double, execute work: @escaping @convention(block) () -> Void) {
        invokedAsyncAfterNow = true
        invokedAsyncAfterNowCount += 1
        invokedAsyncAfterNowParameters = (delay, ())
        invokedAsyncAfterNowParametersList.append((delay, ()))
        if shouldInvokeAsyncAfterNowWork {
            work()
        }
    }

    var invokedAsyncFlags = false
    var invokedAsyncFlagsCount = 0
    var invokedAsyncFlagsParameters: (flags: DispatchWorkItemFlags, Void)?
    var invokedAsyncFlagsParametersList = [(flags: DispatchWorkItemFlags, Void)]()
    var shouldInvokeAsyncFlagsWork = false

    public func async(flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void) {
        invokedAsyncFlags = true
        invokedAsyncFlagsCount += 1
        invokedAsyncFlagsParameters = (flags, ())
        invokedAsyncFlagsParametersList.append((flags, ()))
        if shouldInvokeAsyncFlagsWork {
            work()
        }
    }
}
