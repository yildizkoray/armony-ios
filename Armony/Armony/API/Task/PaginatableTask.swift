//
//  PaginatableTask.swift
//  Armony
//
//  Created by Koray Yıldız on 04.11.22.
//

import Foundation

public protocol PaginatableTask {
    var page: Int { get set }
}

extension PaginatableTask {
    var page: Int {
        return 1
    }
}

final class Paginator {

    private var task: HTTPTask & PaginatableTask
    private(set) var hasNext: Bool

    init(task: HTTPTask & PaginatableTask) {
        self.task = task
        self.hasNext = false
    }

    func execute<R: RestResponse>(service: RestService, type: R.Type) async throws -> R {
        var newTask = task
        newTask.page = 1
        return try await process(service: service, task: newTask, type: type)
    }

    func next<R: RestResponse>(service: RestService, type: R.Type) async throws -> R {
        return try await process(service: service, task: task, type: type)
    }

    private func process<R: RestResponse>(service: RestService, task: HTTPTask & PaginatableTask, type: R.Type) async throws -> R {
        do {
            let response = try await service.execute(task: task, type: type)
            if let index = response.metadata?.page, let hasNext = response.metadata?.hasNext  {
                self.task = task
                self.task.page = index + 1
                self.hasNext = hasNext
            }
            return response
        }
    }
}
