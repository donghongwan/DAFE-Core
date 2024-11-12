// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LinkedList {
    struct Node {
        uint256 value;
        uint256 next;
    }

    struct List {
        mapping(uint256 => Node) nodes;
        uint256 head;
        uint256 tail;
        uint256 size;
    }

    function initialize(List storage list) internal {
        list.head = 0;
        list.tail = 0;
        list.size = 0;
    }

    function append(List storage list, uint256 value) internal {
        uint256 newIndex = list.size + 1;
        list.nodes[newIndex] = Node(value, 0);
        
        if (list.size == 0) {
            list.head = newIndex;
            list.tail = newIndex;
        } else {
            list.nodes[list.tail].next = newIndex;
            list.tail = newIndex;
        }
        
        list.size++;
    }

    function get(List storage list, uint256 index) internal view returns (uint256) {
        require(index > 0 && index <= list.size, "LinkedList: index out of bounds");
        return list.nodes[index].value;
    }

    function getSize(List storage list) internal view returns (uint256) {
        return list.size;
    }
}
