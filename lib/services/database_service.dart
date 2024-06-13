import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/admin_order_placement.dart';
import 'package:my_app/model/customer_order.dart';
import 'package:my_app/model/customer_order_placement.dart';
import 'package:my_app/model/farm_owner_item.dart';
import 'package:my_app/model/item.dart';
import 'package:my_app/model/user.dart';
import 'package:my_app/model/feedback_model.dart';

const String USER_COLLECTION_REF = "user";
const String FEEDBACK_COLLECTION_REF = "feedback";
const String ITEM_COLLECTION_REF = "item";
const String FARM_OWNER_ITEM_COLLECTION_REF = "farm_owner_items";
const String CUSTOMER_ORDER_COLLECTION_REF = "customer_orders";
const String ADMIN_ORDER_COLLECTION_REF = "admin_orders";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference<User> _usersRef;
  late final CollectionReference<Item> _itemsRef;
  late CollectionReference<FarmOwnerItem?> _farmOwnerItemsRef;
  late final CollectionReference<CustomerOrder> _customerOrdersRef;
  late final CollectionReference<AdminOrder> _adminOrdersRef;

  late final CollectionReference<FeedbackModel> _feedbackRef;

  DatabaseService() {
    _usersRef = _firestore.collection(USER_COLLECTION_REF).withConverter<User>(
          fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!),
          toFirestore: (user, _) => user.toJson(),
        );

    _itemsRef = _firestore.collection(ITEM_COLLECTION_REF).withConverter<Item>(
          fromFirestore: (snapshots, _) =>
              Item.fromJson(snapshots.data()!, snapshots.id),
          toFirestore: (item, _) => item.toJson(),
        );

    _farmOwnerItemsRef = _firestore
        .collection(FARM_OWNER_ITEM_COLLECTION_REF)
        .withConverter<FarmOwnerItem>(
          fromFirestore: (snapshots, _) =>
              FarmOwnerItem.fromJson(snapshots.data()!, snapshots.id),
          toFirestore: (item, _) => item.toJson(),
        );

    _customerOrdersRef = _firestore
        .collection(CUSTOMER_ORDER_COLLECTION_REF)
        .withConverter<CustomerOrder>(
          fromFirestore: (snapshots, _) =>
              CustomerOrder.fromJson(snapshots.data()!),
          toFirestore: (order, _) => order.toJson(),
        );

    _feedbackRef = _firestore
        .collection(FEEDBACK_COLLECTION_REF)
        .withConverter<FeedbackModel>(
          fromFirestore: (snapshots, _) =>
              FeedbackModel.fromJson(snapshots.data()!),
          toFirestore: (order, _) => order.toJson(),
        );

    _adminOrdersRef = _firestore
        .collection(ADMIN_ORDER_COLLECTION_REF)
        .withConverter<AdminOrder>(
          fromFirestore: (snapshots, _) =>
              AdminOrder.fromJson(snapshots.data()!),
          toFirestore: (order, _) => order.toJson(),
        );
  }

  // User methods
  Stream<QuerySnapshot<User>> getUsers() {
    return _usersRef.snapshots();
  }

  Future<User?> getUser(String email) async {
    try {
      QuerySnapshot<User> snapshot =
          await _usersRef.where('email', isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return null; // User not found
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<String> userAuthentication(String email, String password) async {
    try {
      QuerySnapshot<User> snapshot =
          await _usersRef.where('email', isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        User user = snapshot.docs.first.data()!;
        if (user.password == password) {
          return user.role;
        } else {
          return 'none';
        }
      } else {
        return 'none'; // User not found
      }
    } catch (e) {
      print("Error fetching user: $e");
      return 'none';
    }
  }

  Future<bool> addUser(User user) async {
    DocumentReference<User> docRef = _usersRef.doc();
    User newUser = User(
      id: docRef.id,
      userName: user.userName,
      address: user.address,
      mobileNumber: user.mobileNumber,
      email: user.email,
      password: user.password,
      role: user.role,
    );
    try {
      await docRef.set(newUser);
      return true;
    } catch (e) {
      print("Error adding user: $e");
      return false;
    }
  }

  Future<void> updateUser(String userId, User user) async {
    try {
      await _usersRef.doc(userId).update(user.toJson());
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersRef.doc(userId).delete();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<List<User>> getUsersByRole(String role) async {
    try {
      QuerySnapshot<User> querySnapshot =
          await _usersRef.where('role', isEqualTo: role).get();
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error fetching users by role: $e");
      return [];
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      QuerySnapshot<User> snapshot =
          await _usersRef.where('email', isEqualTo: email).get();

      if (snapshot.docs.isNotEmpty) {
        User user = snapshot.docs.first.data()!;
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user by email: $e");
      return null;
    }
  }

  // Add new feedback
  Future<bool> addFeedback(String customerEmail, String feedback) async {
    try {
      DocumentReference<FeedbackModel> docRef = _feedbackRef.doc();

      FeedbackModel newFeedback = FeedbackModel(
        id: docRef.id,
        customerEmail: customerEmail,
        feedback: feedback,
      );
      await docRef.set(newFeedback);
      return true;
    } catch (e) {
      print("Error adding feedback: $e");
      return false;
    }
  }

  // Update existing feedback by ID

  // Delete feedback by ID
  Future<bool> deleteFeedback(String feedbackId) async {
    try {
      await _feedbackRef.doc(feedbackId).delete();
      return true;
    } catch (e) {
      print("Error deleting feedback: $e");
      return false;
    }
  }

  // Get a list of all feedbacks
  Future<List<FeedbackModel>> getAllFeedbacks() async {
    try {
      QuerySnapshot<FeedbackModel> querySnapshot = await _feedbackRef.get();
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error fetching feedbacks: $e");
      return [];
    }
  }

  // Get feedback by customer email
  Future<List<FeedbackModel>> getFeedbacksByCustomerEmail(
      String customerEmail) async {
    try {
      QuerySnapshot<FeedbackModel> querySnapshot = await _feedbackRef
          .where('customerEmail', isEqualTo: customerEmail)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error fetching feedbacks by customer email: $e");
      return [];
    }
  }

  // Get feedback by ID
  Future<FeedbackModel?> getFeedbackById(String feedbackId) async {
    try {
      DocumentSnapshot<FeedbackModel> snapshot =
          await _feedbackRef.doc(feedbackId).get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching feedback by ID: $e");
      return null;
    }
  }

  // Item methods
  Stream<QuerySnapshot<Item>> getItems() {
    return _itemsRef.snapshots();
  }

  Future<Item?> getItem(String id) async {
    try {
      DocumentSnapshot<Item> snapshot = await _itemsRef.doc(id).get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null; // Item not found
      }
    } catch (e) {
      print("Error fetching item: $e");
      return null;
    }
  }

  Future<bool> addItem(Item item) async {
    try {
      DocumentReference<Item> docRef = _itemsRef.doc();
      Item newItem = Item(
        id: docRef.id, // Set the generated document ID to the item
        title: item.title,
        category: item.category,
        price: item.price,
        available: item.available,
        quantity: item.quantity,
      );
      await docRef.set(newItem);
      return true;
    } catch (e) {
      print("Error adding item: $e");
      return false;
    }
  }

  Future<void> updateItem(String itemId, Item item) async {
    try {
      await _itemsRef.doc(itemId).update(item.toJson());
    } catch (e) {
      print("Error updating item: $e");
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await _itemsRef.doc(itemId).delete();
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  Future<List<Item>> getAllItems() async {
    try {
      QuerySnapshot querySnapshot = await _itemsRef.get();
      return querySnapshot.docs.map((doc) {
        return Item(
          id: doc.id,
          title: doc['title'],
          price: doc['price'],
          available: doc['available'],
          quantity: doc['quantity'],
          category: doc['category'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching items: $e");
      return []; // Return an empty list if an error occurs
    }
  }

  Stream<QuerySnapshot<FarmOwnerItem?>> getFarmOwnerItems() {
    return _farmOwnerItemsRef.snapshots();
  }

  Future<String> addFarmOwnerItem(FarmOwnerItem item) async {
    try {
      DocumentReference<FarmOwnerItem?> docRef = _farmOwnerItemsRef.doc();
      FarmOwnerItem newFarmOwnerItem = FarmOwnerItem(
          id: docRef.id,
          farmerName: item.farmerName,
          itemName: item.itemName,
          category: item.category,
          quantity: item.quantity,
          available: item.available,
          price: item.price);
      await docRef.set(newFarmOwnerItem);
      return docRef.id;
    } catch (e) {
      print("Error adding farm owner item: $e");
      return '';
    }
  }

  Future<void> updateFarmOwnerItem(String id, FarmOwnerItem newItem) async {
    try {
      await _farmOwnerItemsRef.doc(id).set(newItem);
    } catch (e) {
      print("Error updating farm owner item: $e");
    }
  }

  Future<void> deleteFarmOwnerItem(String id) async {
    try {
      await _farmOwnerItemsRef.doc(id).delete();
    } catch (e) {
      print("Error deleting farm owner item: $e");
    }
  }

  Future<List<FarmOwnerItem?>> getFarmOwnerItemsByFarmerName(
      String farmerName) async {
    try {
      QuerySnapshot<FarmOwnerItem?> snapshot = await _farmOwnerItemsRef
          .where('farmerName', isEqualTo: farmerName)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return FarmOwnerItem(
            id: doc.id,
            itemName: doc['itemName'],
            farmerName: doc['farmerName'],
            price: doc['price'],
            available: doc['available'],
            quantity: doc['quantity'],
            category: doc['category'],
          );
        }).toList();
      } else {
        return []; // Order not found
      }
    } catch (e) {
      print("Error fetching order: $e");
      return [];
    }
  }

  Future<List<FarmOwnerItem>> getAllFarmOwnerItems() async {
    try {
      QuerySnapshot querySnapshot = await _farmOwnerItemsRef.get();
      return querySnapshot.docs.map((doc) {
        return FarmOwnerItem(
          id: doc.id,
          itemName: doc['itemName'],
          farmerName: doc['farmerName'],
          price: doc['price'],
          available: doc['available'],
          quantity: doc['quantity'],
          category: doc['category'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching farm owner items: $e");
      return [];
    }
  }

  // CustomerOrder methods
  Stream<QuerySnapshot<CustomerOrder>> getCustomerOrders() {
    return _customerOrdersRef.snapshots();
  }

  Future<CustomerOrder?> getCustomerOrder(int id) async {
    try {
      QuerySnapshot<CustomerOrder> snapshot =
          await _customerOrdersRef.where('id', isEqualTo: id).get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return null; // Order not found
      }
    } catch (e) {
      print("Error fetching order: $e");
      return null;
    }
  }

  Future<CustomerOrder> addCustomerOrder(CustomerOrder order) async {
    DocumentReference<CustomerOrder> docRef = _customerOrdersRef.doc();
    CustomerOrder newOrder = CustomerOrder(
        id: docRef.id,
        quantity: order.quantity,
        itemName: order.itemName,
        customerId: order.customerId,
        status: order.status,
        onePrice: order.onePrice,
        totalPrice: order.totalPrice);

    await docRef.set(newOrder);
    return newOrder;
  }

  Future<void> updateCustomerOrder(String orderId, CustomerOrder order) async {
    try {
      await _customerOrdersRef.doc(orderId).update(order.toJson());
    } catch (e) {
      print("Error updating order: $e");
    }
  }

  Future<void> deleteCustomerOrder(String orderId) async {
    try {
      await _customerOrdersRef.doc(orderId).delete();
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  Future<List<CustomerOrder?>> getCustomerOrderByCustomerIdeAndCategory(
      String customerId, String category) async {
    try {
      QuerySnapshot<CustomerOrder?> snapshot = await _customerOrdersRef
          .where('customerId', isEqualTo: customerId)
          .where('category', isEqualTo: category)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => doc.data()!).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching items by farmer name and category: $e");
      return [];
    }
  }

  Future<List<CustomerOrder>> getCustomerOrdersByCustomerId(
      String customerId) async {
    try {
      QuerySnapshot<CustomerOrder> querySnapshot = await _customerOrdersRef
          .where('customerId', isEqualTo: customerId)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error fetching orders by customer ID: $e");
      return [];
    }
  }

  // AdminOrder methods
  Stream<QuerySnapshot<AdminOrder>> getAdminOrders() {
    return _adminOrdersRef.snapshots();
  }

  Future<AdminOrder?> getAdminOrder(String id) async {
    try {
      DocumentSnapshot<AdminOrder> snapshot =
          await _adminOrdersRef.doc(id).get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null; // Order not found
      }
    } catch (e) {
      print("Error fetching admin order: $e");
      return null;
    }
  }

  Future<bool> addAdminOrder(AdminOrder order) async {
    try {
      DocumentReference<AdminOrder> docRef = _adminOrdersRef.doc();
      AdminOrder newOrder = AdminOrder(
        id: docRef.id,
        quantity: order.quantity,
        itemName: order.itemName,
        farmerEmail: order.farmerEmail,
        status: order.status,
        totalPrice: order.totalPrice,
      );
      await docRef.set(newOrder);
      return true;
    } catch (e) {
      print("Error adding admin order: $e");
      return false;
    }
  }

  Future<void> updateAdminOrder(String orderId, AdminOrder order) async {
    try {
      await _adminOrdersRef.doc(orderId).update(order.toJson());
    } catch (e) {
      print("Error updating admin order: $e");
    }
  }

  Future<void> deleteAdminOrder(String orderId) async {
    try {
      await _adminOrdersRef.doc(orderId).delete();
    } catch (e) {
      print("Error deleting admin order: $e");
    }
  }

  Future<List<AdminOrder>> getAdminOrdersByFarmerEmail(
      String farmerEmail) async {
    try {
      QuerySnapshot<AdminOrder> querySnapshot = await _adminOrdersRef
          .where('farmerEmail', isEqualTo: farmerEmail)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()!).toList();
    } catch (e) {
      print("Error fetching admin orders by farmer email: $e");
      return [];
    }
  }

  Future<List<AdminOrder>> getAllAdminOrders() async {
    try {
      QuerySnapshot querySnapshot = await _adminOrdersRef.get();
      return querySnapshot.docs.map((doc) {
        return AdminOrder(
            quantity: doc['quantity'],
            itemName: doc['itemName'],
            farmerEmail: doc['farmerEmail'],
            status: doc['status'],
            totalPrice: doc['totalPrice']);
      }).toList();
    } catch (e) {
      print("Error fetching items: $e");
      return []; // Return an empty list if an error occurs
    }
  }
}
