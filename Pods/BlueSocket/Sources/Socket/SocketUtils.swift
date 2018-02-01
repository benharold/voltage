//
//  SocketUtils.swift
//  BlueSocket
//
//  Created by Bill Abt on 11/19/15.
//  Copyright © 2016 IBM. All rights reserved.
//
// 	Licensed under the Apache License, Version 2.0 (the "License");
// 	you may not use this file except in compliance with the License.
// 	You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// 	Unless required by applicable law or agreed to in writing, software
// 	distributed under the License is distributed on an "AS IS" BASIS,
// 	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 	See the License for the specific language governing permissions and
// 	limitations under the License.
//

#if os(macOS) || os(iOS) || os(tvOS)
	import Darwin
#elseif os(Linux)
	import Glibc
#endif

import Foundation

//
// Great help with this from
// https://blog.obdev.at/representing-socket-addresses-in-swift-using-enums/
//
extension Socket.Address {
	
	///
	/// Call a low level socket function using the specified socket address pointer.
	///
	/// - Parameters:
	///		- body:		The closure containing the call to the low level function.
	///
	///	- Returns:		The result of executing the closure.
	///
	func withSockAddrPointer<Result>(body: (UnsafePointer<sockaddr>, socklen_t) throws -> Result) rethrows -> Result {
		
		///
		/// Internal function to call do the cast and call to the closure.
		///
		func castAndCall<T>(_ address: T, _ body: (UnsafePointer<sockaddr>, socklen_t) throws -> Result) rethrows -> Result {
			var localAddress = address // We need a `var` here for the `&`.
			return try withUnsafePointer(to: &localAddress) {
				return try $0.withMemoryRebound(to: sockaddr.self, capacity: 1, {
					return try body($0, socklen_t(MemoryLayout<T>.size))
				})
			}
		}
		
		switch self {
		case .ipv4(let address):
			return try castAndCall(address, body)
		case .ipv6(let address):
			return try castAndCall(address, body)
		case .unix(let address):
			return try castAndCall(address, body)
		}
	}
}

extension Socket.Address {
	
	///
	/// Creates a Socket.Address
	///
	/// - Parameters:
	///		- addressProvider:	Tuple containing pointers to the sockaddr and its length.
	///
	///	- Returns:				Newly initialized Socket.Address.
	///
	init?(addressProvider: (UnsafeMutablePointer<sockaddr>, UnsafeMutablePointer<socklen_t>) throws -> Void) rethrows {
		
		var addressStorage = sockaddr_storage()
		var addressStorageLength = socklen_t(MemoryLayout.size(ofValue: addressStorage))
		try withUnsafeMutablePointer(to: &addressStorage) {
			try $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { addressPointer in
				try withUnsafeMutablePointer(to: &addressStorageLength) { addressLengthPointer in
					try addressProvider(addressPointer, addressLengthPointer)
				}
			}
		}
		
		switch Int32(addressStorage.ss_family) {
		case AF_INET:
			self = withUnsafePointer(to: &addressStorage) {
				return $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
					return Socket.Address.ipv4($0.pointee)
				}
			}
		case AF_INET6:
			self = withUnsafePointer(to: &addressStorage) {
				return $0.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) {
					return Socket.Address.ipv6($0.pointee)
				}
			}
		case AF_UNIX:
			self = withUnsafePointer(to: &addressStorage) {
				return $0.withMemoryRebound(to: sockaddr_un.self, capacity: 1) {
					return Socket.Address.unix($0.pointee)
				}
			}
		default:
			return nil
		}
	}
}

#if arch(arm) && os(Linux)
	
	public struct FD {
		
		/// Replacement for FD_ZERO macro
		
		public static func ZERO(set: inout fd_set) {
			set.__fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		}
		
		
		/// Replacement for FD_SET macro
		
		public static func SET(fd: Int32, set: inout fd_set) {
			let intOffset = Int32(fd / 32)
			let bitOffset: Int32 = Int32(fd % 32)
			let mask: Int32 = 1 << bitOffset
			switch intOffset {
			case 0: set.__fds_bits.0 = set.__fds_bits.0 | mask
			case 1: set.__fds_bits.1 = set.__fds_bits.1 | mask
			case 2: set.__fds_bits.2 = set.__fds_bits.2 | mask
			case 3: set.__fds_bits.3 = set.__fds_bits.3 | mask
			case 4: set.__fds_bits.4 = set.__fds_bits.4 | mask
			case 5: set.__fds_bits.5 = set.__fds_bits.5 | mask
			case 6: set.__fds_bits.6 = set.__fds_bits.6 | mask
			case 7: set.__fds_bits.7 = set.__fds_bits.7 | mask
			case 8: set.__fds_bits.8 = set.__fds_bits.8 | mask
			case 9: set.__fds_bits.9 = set.__fds_bits.9 | mask
			case 10: set.__fds_bits.10 = set.__fds_bits.10 | mask
			case 11: set.__fds_bits.11 = set.__fds_bits.11 | mask
			case 12: set.__fds_bits.12 = set.__fds_bits.12 | mask
			case 13: set.__fds_bits.13 = set.__fds_bits.13 | mask
			case 14: set.__fds_bits.14 = set.__fds_bits.14 | mask
			case 15: set.__fds_bits.15 = set.__fds_bits.15 | mask
			case 16: set.__fds_bits.16 = set.__fds_bits.16 | mask
			case 17: set.__fds_bits.17 = set.__fds_bits.17 | mask
			case 18: set.__fds_bits.18 = set.__fds_bits.18 | mask
			case 19: set.__fds_bits.19 = set.__fds_bits.19 | mask
			case 20: set.__fds_bits.20 = set.__fds_bits.20 | mask
			case 21: set.__fds_bits.21 = set.__fds_bits.21 | mask
			case 22: set.__fds_bits.22 = set.__fds_bits.22 | mask
			case 23: set.__fds_bits.23 = set.__fds_bits.23 | mask
			case 24: set.__fds_bits.24 = set.__fds_bits.24 | mask
			case 25: set.__fds_bits.25 = set.__fds_bits.25 | mask
			case 26: set.__fds_bits.26 = set.__fds_bits.26 | mask
			case 27: set.__fds_bits.27 = set.__fds_bits.27 | mask
			case 28: set.__fds_bits.28 = set.__fds_bits.28 | mask
			case 29: set.__fds_bits.29 = set.__fds_bits.29 | mask
			case 30: set.__fds_bits.20 = set.__fds_bits.30 | mask
			case 31: set.__fds_bits.31 = set.__fds_bits.31 | mask
			default: break
			}
		}
		
		
		/// Replacement for FD_CLR macro
		
		public static func CLR(fd: Int32, set: inout fd_set) {
			let intOffset = Int32(fd / 32)
			let bitOffset: Int32 = Int32(fd % 32)
			let mask: Int32 = ~(1 << bitOffset)
			switch intOffset {
			case 0: set.__fds_bits.0 = set.__fds_bits.0 & mask
			case 1: set.__fds_bits.1 = set.__fds_bits.1 & mask
			case 2: set.__fds_bits.2 = set.__fds_bits.2 & mask
			case 3: set.__fds_bits.3 = set.__fds_bits.3 & mask
			case 4: set.__fds_bits.4 = set.__fds_bits.4 & mask
			case 5: set.__fds_bits.5 = set.__fds_bits.5 & mask
			case 6: set.__fds_bits.6 = set.__fds_bits.6 & mask
			case 7: set.__fds_bits.7 = set.__fds_bits.7 & mask
			case 8: set.__fds_bits.8 = set.__fds_bits.8 & mask
			case 9: set.__fds_bits.9 = set.__fds_bits.9 & mask
			case 10: set.__fds_bits.10 = set.__fds_bits.10 & mask
			case 11: set.__fds_bits.11 = set.__fds_bits.11 & mask
			case 12: set.__fds_bits.12 = set.__fds_bits.12 & mask
			case 13: set.__fds_bits.13 = set.__fds_bits.13 & mask
			case 14: set.__fds_bits.14 = set.__fds_bits.14 & mask
			case 15: set.__fds_bits.15 = set.__fds_bits.15 & mask
			case 16: set.__fds_bits.16 = set.__fds_bits.16 & mask
			case 17: set.__fds_bits.17 = set.__fds_bits.17 & mask
			case 18: set.__fds_bits.18 = set.__fds_bits.18 & mask
			case 19: set.__fds_bits.19 = set.__fds_bits.19 & mask
			case 20: set.__fds_bits.20 = set.__fds_bits.20 & mask
			case 21: set.__fds_bits.21 = set.__fds_bits.21 & mask
			case 22: set.__fds_bits.22 = set.__fds_bits.22 & mask
			case 23: set.__fds_bits.23 = set.__fds_bits.23 & mask
			case 24: set.__fds_bits.24 = set.__fds_bits.24 & mask
			case 25: set.__fds_bits.25 = set.__fds_bits.25 & mask
			case 26: set.__fds_bits.26 = set.__fds_bits.26 & mask
			case 27: set.__fds_bits.27 = set.__fds_bits.27 & mask
			case 28: set.__fds_bits.28 = set.__fds_bits.28 & mask
			case 29: set.__fds_bits.29 = set.__fds_bits.29 & mask
			case 30: set.__fds_bits.20 = set.__fds_bits.30 & mask
			case 31: set.__fds_bits.31 = set.__fds_bits.31 & mask
			default: break
			}
		}
		
		
		/// Replacement for FD_ISSET macro
		
		public static func ISSET(fd: Int32, set: inout fd_set) -> Bool {
			let intOffset = Int32(fd / 32)
			let bitOffset = Int32(fd % 32)
			let mask: Int32 = 1 << bitOffset
			switch intOffset {
			case 0: return set.__fds_bits.0 & mask != 0
			case 1: return set.__fds_bits.1 & mask != 0
			case 2: return set.__fds_bits.2 & mask != 0
			case 3: return set.__fds_bits.3 & mask != 0
			case 4: return set.__fds_bits.4 & mask != 0
			case 5: return set.__fds_bits.5 & mask != 0
			case 6: return set.__fds_bits.6 & mask != 0
			case 7: return set.__fds_bits.7 & mask != 0
			case 8: return set.__fds_bits.8 & mask != 0
			case 9: return set.__fds_bits.9 & mask != 0
			case 10: return set.__fds_bits.10 & mask != 0
			case 11: return set.__fds_bits.11 & mask != 0
			case 12: return set.__fds_bits.12 & mask != 0
			case 13: return set.__fds_bits.13 & mask != 0
			case 14: return set.__fds_bits.14 & mask != 0
			case 15: return set.__fds_bits.15 & mask != 0
			case 16: return set.__fds_bits.16 & mask != 0
			case 17: return set.__fds_bits.17 & mask != 0
			case 18: return set.__fds_bits.18 & mask != 0
			case 19: return set.__fds_bits.19 & mask != 0
			case 20: return set.__fds_bits.20 & mask != 0
			case 21: return set.__fds_bits.21 & mask != 0
			case 22: return set.__fds_bits.22 & mask != 0
			case 23: return set.__fds_bits.23 & mask != 0
			case 24: return set.__fds_bits.24 & mask != 0
			case 25: return set.__fds_bits.25 & mask != 0
			case 26: return set.__fds_bits.26 & mask != 0
			case 27: return set.__fds_bits.27 & mask != 0
			case 28: return set.__fds_bits.28 & mask != 0
			case 29: return set.__fds_bits.29 & mask != 0
			case 30: return set.__fds_bits.30 & mask != 0
			case 31: return set.__fds_bits.31 & mask != 0
			default: return false
			}
			
		}
	}
	
#elseif os(Linux)
	
	public struct FD {
		
		/// Replacement for FD_ZERO macro
		
		public static func ZERO(set: inout fd_set) {
			set.__fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		}
		
		
		/// Replacement for FD_SET macro
		
		public static func SET(fd: Int32, set: inout fd_set) {
			let intOffset = Int(fd / 16)
			let bitOffset: Int = Int(fd % 16)
			let mask: Int = 1 << bitOffset
			switch intOffset {
			case 0: set.__fds_bits.0 = set.__fds_bits.0 | mask
			case 1: set.__fds_bits.1 = set.__fds_bits.1 | mask
			case 2: set.__fds_bits.2 = set.__fds_bits.2 | mask
			case 3: set.__fds_bits.3 = set.__fds_bits.3 | mask
			case 4: set.__fds_bits.4 = set.__fds_bits.4 | mask
			case 5: set.__fds_bits.5 = set.__fds_bits.5 | mask
			case 6: set.__fds_bits.6 = set.__fds_bits.6 | mask
			case 7: set.__fds_bits.7 = set.__fds_bits.7 | mask
			case 8: set.__fds_bits.8 = set.__fds_bits.8 | mask
			case 9: set.__fds_bits.9 = set.__fds_bits.9 | mask
			case 10: set.__fds_bits.10 = set.__fds_bits.10 | mask
			case 11: set.__fds_bits.11 = set.__fds_bits.11 | mask
			case 12: set.__fds_bits.12 = set.__fds_bits.12 | mask
			case 13: set.__fds_bits.13 = set.__fds_bits.13 | mask
			case 14: set.__fds_bits.14 = set.__fds_bits.14 | mask
			case 15: set.__fds_bits.15 = set.__fds_bits.15 | mask
			default: break
			}
		}
		
		
		/// Replacement for FD_CLR macro
		
		public static func CLR(fd: Int32, set: inout fd_set) {
			let intOffset = Int(fd / 16)
			let bitOffset: Int = Int(fd % 16)
			let mask: Int = ~(1 << bitOffset)
			switch intOffset {
			case 0: set.__fds_bits.0 = set.__fds_bits.0 & mask
			case 1: set.__fds_bits.1 = set.__fds_bits.1 & mask
			case 2: set.__fds_bits.2 = set.__fds_bits.2 & mask
			case 3: set.__fds_bits.3 = set.__fds_bits.3 & mask
			case 4: set.__fds_bits.4 = set.__fds_bits.4 & mask
			case 5: set.__fds_bits.5 = set.__fds_bits.5 & mask
			case 6: set.__fds_bits.6 = set.__fds_bits.6 & mask
			case 7: set.__fds_bits.7 = set.__fds_bits.7 & mask
			case 8: set.__fds_bits.8 = set.__fds_bits.8 & mask
			case 9: set.__fds_bits.9 = set.__fds_bits.9 & mask
			case 10: set.__fds_bits.10 = set.__fds_bits.10 & mask
			case 11: set.__fds_bits.11 = set.__fds_bits.11 & mask
			case 12: set.__fds_bits.12 = set.__fds_bits.12 & mask
			case 13: set.__fds_bits.13 = set.__fds_bits.13 & mask
			case 14: set.__fds_bits.14 = set.__fds_bits.14 & mask
			case 15: set.__fds_bits.15 = set.__fds_bits.15 & mask
			default: break
			}
		}
		
		
		/// Replacement for FD_ISSET macro
		
		public static func ISSET(fd: Int32, set: inout fd_set) -> Bool {
			let intOffset = Int(fd / 16)
			let bitOffset = Int(fd % 16)
			let mask: Int = 1 << bitOffset
			switch intOffset {
			case 0: return set.__fds_bits.0 & mask != 0
			case 1: return set.__fds_bits.1 & mask != 0
			case 2: return set.__fds_bits.2 & mask != 0
			case 3: return set.__fds_bits.3 & mask != 0
			case 4: return set.__fds_bits.4 & mask != 0
			case 5: return set.__fds_bits.5 & mask != 0
			case 6: return set.__fds_bits.6 & mask != 0
			case 7: return set.__fds_bits.7 & mask != 0
			case 8: return set.__fds_bits.8 & mask != 0
			case 9: return set.__fds_bits.9 & mask != 0
			case 10: return set.__fds_bits.10 & mask != 0
			case 11: return set.__fds_bits.11 & mask != 0
			case 12: return set.__fds_bits.12 & mask != 0
			case 13: return set.__fds_bits.13 & mask != 0
			case 14: return set.__fds_bits.14 & mask != 0
			case 15: return set.__fds_bits.15 & mask != 0
			default: return false
			}
		}
	}
	
#else
	
	public struct FD {
		
		/// Replacement for FD_ZERO macro
		
		public static func ZERO(set: inout fd_set) {
			set.fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		}
		
		
		/// Replacement for FD_SET macro
		
		public static func SET(fd: Int32, set: inout fd_set) {
			let intOffset = Int32(fd / 32)
			let bitOffset = fd % 32
			let mask: Int32 = 1 << bitOffset
			switch intOffset {
			case 0: set.fds_bits.0 = set.fds_bits.0 | mask
			case 1: set.fds_bits.1 = set.fds_bits.1 | mask
			case 2: set.fds_bits.2 = set.fds_bits.2 | mask
			case 3: set.fds_bits.3 = set.fds_bits.3 | mask
			case 4: set.fds_bits.4 = set.fds_bits.4 | mask
			case 5: set.fds_bits.5 = set.fds_bits.5 | mask
			case 6: set.fds_bits.6 = set.fds_bits.6 | mask
			case 7: set.fds_bits.7 = set.fds_bits.7 | mask
			case 8: set.fds_bits.8 = set.fds_bits.8 | mask
			case 9: set.fds_bits.9 = set.fds_bits.9 | mask
			case 10: set.fds_bits.10 = set.fds_bits.10 | mask
			case 11: set.fds_bits.11 = set.fds_bits.11 | mask
			case 12: set.fds_bits.12 = set.fds_bits.12 | mask
			case 13: set.fds_bits.13 = set.fds_bits.13 | mask
			case 14: set.fds_bits.14 = set.fds_bits.14 | mask
			case 15: set.fds_bits.15 = set.fds_bits.15 | mask
			case 16: set.fds_bits.16 = set.fds_bits.16 | mask
			case 17: set.fds_bits.17 = set.fds_bits.17 | mask
			case 18: set.fds_bits.18 = set.fds_bits.18 | mask
			case 19: set.fds_bits.19 = set.fds_bits.19 | mask
			case 20: set.fds_bits.20 = set.fds_bits.20 | mask
			case 21: set.fds_bits.21 = set.fds_bits.21 | mask
			case 22: set.fds_bits.22 = set.fds_bits.22 | mask
			case 23: set.fds_bits.23 = set.fds_bits.23 | mask
			case 24: set.fds_bits.24 = set.fds_bits.24 | mask
			case 25: set.fds_bits.25 = set.fds_bits.25 | mask
			case 26: set.fds_bits.26 = set.fds_bits.26 | mask
			case 27: set.fds_bits.27 = set.fds_bits.27 | mask
			case 28: set.fds_bits.28 = set.fds_bits.28 | mask
			case 29: set.fds_bits.29 = set.fds_bits.29 | mask
			case 30: set.fds_bits.30 = set.fds_bits.30 | mask
			case 31: set.fds_bits.31 = set.fds_bits.31 | mask
			default: break
			}
		}
		
		
		/// Replacement for FD_CLR macro
		
		public static func CLR(fd: Int32, set: inout fd_set) {
			let intOffset = Int32(fd / 32)
			let bitOffset = fd % 32
			let mask: Int32 = ~(1 << bitOffset)
			switch intOffset {
			case 0: set.fds_bits.0 = set.fds_bits.0 & mask
			case 1: set.fds_bits.1 = set.fds_bits.1 & mask
			case 2: set.fds_bits.2 = set.fds_bits.2 & mask
			case 3: set.fds_bits.3 = set.fds_bits.3 & mask
			case 4: set.fds_bits.4 = set.fds_bits.4 & mask
			case 5: set.fds_bits.5 = set.fds_bits.5 & mask
			case 6: set.fds_bits.6 = set.fds_bits.6 & mask
			case 7: set.fds_bits.7 = set.fds_bits.7 & mask
			case 8: set.fds_bits.8 = set.fds_bits.8 & mask
			case 9: set.fds_bits.9 = set.fds_bits.9 & mask
			case 10: set.fds_bits.10 = set.fds_bits.10 & mask
			case 11: set.fds_bits.11 = set.fds_bits.11 & mask
			case 12: set.fds_bits.12 = set.fds_bits.12 & mask
			case 13: set.fds_bits.13 = set.fds_bits.13 & mask
			case 14: set.fds_bits.14 = set.fds_bits.14 & mask
			case 15: set.fds_bits.15 = set.fds_bits.15 & mask
			case 16: set.fds_bits.16 = set.fds_bits.16 & mask
			case 17: set.fds_bits.17 = set.fds_bits.17 & mask
			case 18: set.fds_bits.18 = set.fds_bits.18 & mask
			case 19: set.fds_bits.19 = set.fds_bits.19 & mask
			case 20: set.fds_bits.20 = set.fds_bits.20 & mask
			case 21: set.fds_bits.21 = set.fds_bits.21 & mask
			case 22: set.fds_bits.22 = set.fds_bits.22 & mask
			case 23: set.fds_bits.23 = set.fds_bits.23 & mask
			case 24: set.fds_bits.24 = set.fds_bits.24 & mask
			case 25: set.fds_bits.25 = set.fds_bits.25 & mask
			case 26: set.fds_bits.26 = set.fds_bits.26 & mask
			case 27: set.fds_bits.27 = set.fds_bits.27 & mask
			case 28: set.fds_bits.28 = set.fds_bits.28 & mask
			case 29: set.fds_bits.29 = set.fds_bits.29 & mask
			case 30: set.fds_bits.30 = set.fds_bits.30 & mask
			case 31: set.fds_bits.31 = set.fds_bits.31 & mask
			default: break
			}
		}
		
		
		/// Replacement for FD_ISSET macro
		
		public static func ISSET(fd: Int32, set: inout fd_set) -> Bool {
			let intOffset = Int32(fd / 32)
			let bitOffset = fd % 32
			let mask: Int32 = 1 << bitOffset
			switch intOffset {
			case 0: return set.fds_bits.0 & mask != 0
			case 1: return set.fds_bits.1 & mask != 0
			case 2: return set.fds_bits.2 & mask != 0
			case 3: return set.fds_bits.3 & mask != 0
			case 4: return set.fds_bits.4 & mask != 0
			case 5: return set.fds_bits.5 & mask != 0
			case 6: return set.fds_bits.6 & mask != 0
			case 7: return set.fds_bits.7 & mask != 0
			case 8: return set.fds_bits.8 & mask != 0
			case 9: return set.fds_bits.9 & mask != 0
			case 10: return set.fds_bits.10 & mask != 0
			case 11: return set.fds_bits.11 & mask != 0
			case 12: return set.fds_bits.12 & mask != 0
			case 13: return set.fds_bits.13 & mask != 0
			case 14: return set.fds_bits.14 & mask != 0
			case 15: return set.fds_bits.15 & mask != 0
			case 16: return set.fds_bits.16 & mask != 0
			case 17: return set.fds_bits.17 & mask != 0
			case 18: return set.fds_bits.18 & mask != 0
			case 19: return set.fds_bits.19 & mask != 0
			case 20: return set.fds_bits.20 & mask != 0
			case 21: return set.fds_bits.21 & mask != 0
			case 22: return set.fds_bits.22 & mask != 0
			case 23: return set.fds_bits.23 & mask != 0
			case 24: return set.fds_bits.24 & mask != 0
			case 25: return set.fds_bits.25 & mask != 0
			case 26: return set.fds_bits.26 & mask != 0
			case 27: return set.fds_bits.27 & mask != 0
			case 28: return set.fds_bits.28 & mask != 0
			case 29: return set.fds_bits.29 & mask != 0
			case 30: return set.fds_bits.30 & mask != 0
			case 31: return set.fds_bits.31 & mask != 0
			default: return false
			}
			
		}
	}
	
#endif

