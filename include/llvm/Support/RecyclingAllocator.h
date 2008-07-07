//==- llvm/Support/RecyclingAllocator.h - Recycling Allocator ----*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the RecyclingAllocator class.  See the doxygen comment for
// RecyclingAllocator for more details on the implementation.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_RECYCLINGALLOCATOR_H
#define LLVM_SUPPORT_RECYCLINGALLOCATOR_H

#include <cassert>
#include "llvm/Support/Recycler.h"
#include "llvm/ADT/STLExtras.h"

namespace llvm {

/// RecyclingAllocator - This class wraps an Allocator, adding the
/// functionality of recycling deleted objects.
///
template<class AllocatorType, class T, class LargestT = T>
class RecyclingAllocator {
private:
  /// Base - Implementation details.
  ///
  Recycler<T, LargestT> Base;

  /// Allocator - The wrapped allocator.
  ///
  AllocatorType Allocator;

public:
  ~RecyclingAllocator() { Base.clear(Allocator); }

  /// Allocate - Return a pointer to storage for an object of type
  /// SubClass. The storage may be either newly allocated or recycled.
  ///
  template<class SubClass>
  SubClass *Allocate() { return Base.Allocate<SubClass>(Allocator); }

  T *Allocate() { return Base.Allocate(Allocator); }

  /// Deallocate - Release storage for the pointed-to object. The
  /// storage will be kept track of and may be recycled.
  ///
  template<class SubClass>
  void Deallocate(SubClass* E) { return Base.Deallocate(Allocator, E); }

  void PrintStats() { Base.PrintStats(); }
};

}

#endif
