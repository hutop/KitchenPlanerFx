/**
 * DATA STRUCTURES FOR GAME PROGRAMMERS
 * Copyright (c) 2007 Michael Baczynski, http://www.polygonal.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package de.polygonal.ds
{
	/**
	 * A heap is a special kind of binary tree in which every node is
	 * greater than all of its children. The implementation is based on
	 * an arrayed binary tree. It can be used as an efficient priority queue.
	 * @see PriorityQueue
	 */
	public class Heap implements Collection
	{
		public var _heap:Array;
		
		private var _size:int;
		private var _count:int;
		private var _compare:Function;
		
		/**
		 * Initializes a new heap.
		 */
		public function Heap(size:int, compare:Function = null)
		{
			_heap = new Array(_size = size + 1);
			_count = 0;
			
			if (compare == null)
			{
				_compare = function(a:int, b:int):int
				{
					return a - b;
				};
			}
			else
				_compare = compare;
		}
		
		/**
		 * The heap's front item.
		 */
		public function get front():*
		{
			return _heap[1];
		}
		
		/**
		 * Enqueues some data.
		 * 
		 * @param obj The data.
		 * @return false if the queue is full, otherwise true.
		 */
		public function enqueue(obj:*):Boolean
		{
			if (_count + 1 < _size)
			{
				_heap[++_count] = obj;
				walkUp(_count);
				return true;
			}
			return false;
		}
		
		/**
		 * Dequeues and returns the front item.
		 * 
		 * @return The heap's front item or null if it's is empty.
		 */
		public function dequeue():*
		{
			if (_count >= 1)
			{
				var o:* = _heap[1];
				
				_heap[1] = _heap[_count];
				delete _heap[_count];
				
				walkDown(1);
				_count--;
				return o;
			}
			return null;
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			for (var i:int = 1; i <= _count; i++)
			{
				if (_heap[i] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * Clears all items.
		 */
		public function clear():void
		{
			_heap = new Array(_size);
			_count = 0;
		}
		
		/**
		 * Returns an iterator object pointing to the front
		 * item.
		 * 
		 * @return An iterator object.
		 */
		public function getIterator():Iterator
		{
			return new HeapIterator(this);
		}
		
		/**
		 * The total number of items in the heap.
		 */
		public function get size():int
		{
			return _count;
		}
		
		/**
		 * Checks if the heap is empty.
		 */
		public function isEmpty():Boolean
		{
			return false;
		}
		
		/**
		 * The maximum allowed size of the queue.
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Converts the heap into an array.
		 * 
		 * @return An array containing all heap values.
		 */
		public function toArray():Array
		{
			return _heap.slice(1, _count + 1);
		}
		
		/**
		 * Prints all elements (for debug/demo purposes only).
		 */
		public function dump():String
		{
			var s:String = "Heap\n{\n";
			var k:int = _count + 1;
			for (var i:int = 1; i < k; i++)
			{
				s += "\t" + _heap[i] + "\n";
			}
			s += "\n}";
			return s;
		}
		
		private function walkUp(index:int):void
		{
			var parent:int = index >> 1;
			var tmp:* = _heap[index];
			while (parent > 0)
			{
				if (_compare(tmp, _heap[parent]) > 0)
				{
					_heap[index] = _heap[parent];
					index = parent;
					parent >>= 1;
				}
				else break;
			}
			_heap[index] = tmp;
		}
		
		private function walkDown(index:int):void
		{
			var child:int = index << 1;
			
			var tmp:* = _heap[index];
			
			while (child < _count)
			{
				if (child < _count - 1)
				{
					if (_compare(_heap[child], _heap[int(child + 1)]) < 0)
						child++;
				}
				if (_compare(tmp, _heap[child]) < 0)
				{
					_heap[index] = _heap[child];
					index = child;
					child <<= 1;
				}
				else break;
			}
			_heap[index] = tmp;
		}
	}
}

import de.polygonal.ds.Heap;
import de.polygonal.ds.Iterator;

internal class HeapIterator implements Iterator
{
	private var _values:Array;
	private var _length:int;
	private var _cursor:int;
	
	public function HeapIterator(heap:Heap)
	{
		_values = heap.toArray();
		_length = _values.length;
		_cursor = 0;
	}
	
	public function get data():*
	{
		return _values[_cursor];
	}
	
	public function set data(obj:*):void
	{
		_values[_cursor] = obj;
	}
	
	public function start():void
	{
		_cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _length;
	}
	
	public function next():*
	{
		return _values[_cursor++];
	}
}