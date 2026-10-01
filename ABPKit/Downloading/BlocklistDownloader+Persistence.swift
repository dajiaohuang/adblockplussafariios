/*
 * This file is part of Adblock Plus <https://adblockplus.org/>,
 * Copyright (C) 2006-present eyeo GmbH
 *
 * Adblock Plus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Adblock Plus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Adblock Plus.  If not, see <http://www.gnu.org/licenses/>.
 */

extension BlockListDownloader {
    /// Return the filter list name for a given task identifier.
    internal
    func filterListName(for taskIdentifier: Int) throws -> FilterListName? {
        guard let models = try? pstr.loadFilterListModels() else {
            return nil
        }
        var result: FilterListName?
        var cnt = 0
        for list in models where list.taskIdentifier == taskIdentifier {
            result = list.name
            cnt += 1
        }
        if cnt != 0 && cnt != 1 {
            throw ABPFilterListError.ambiguousModels
        }
        return result
    }

    internal
    func filterList(withName name: String?) throws -> FilterList? {
        guard name != nil else { return nil }
        guard let models = try? pstr.loadFilterListModels() else {
            throw ABPFilterListError.failedLoadModels
        }
        var result: FilterList?
        var cnt = 0
        for list in models where list.name == name {
            cnt += 1
            result = list
        }
        if cnt != 0 && cnt != 1 {
            throw ABPFilterListError.ambiguousModels
        }
        return result
    }

    /// Move a file to a destination, replacing an existing file when possible.
    /// - Returns: True if the move completed successfully.
    internal
    func moveOrReplaceItem(source: URL,
                           destination: URL?) -> Bool {
        guard let uwDestination = destination else { return false }
        let fileManager = FileManager.default
        let destPath = uwDestination.path
        let exists = fileManager.fileExists(atPath: destPath)
        if exists {
            do {
                try fileManager.removeItem(atPath: destPath)
            } catch {
                return false
            }
        }
        do {
            try fileManager.moveItem(at: source,
                                     to: uwDestination)
            return true
        } catch {
            return false
        }
    }
}
