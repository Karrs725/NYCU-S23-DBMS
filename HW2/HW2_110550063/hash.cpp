#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <cmath>
#include "hash.h"
#include <bitset>
#include "utils.h"

using namespace std;

hash_entry::hash_entry(int key, int value){
	this->key = key;
	this->value = value;
	this->next = nullptr;
}

hash_bucket::hash_bucket(int hash_key, int depth){
	this->hash_key = hash_key;
	this->local_depth = depth;
	this->num_entries = 0;
	this->first = nullptr;
}

/* Free the memory alocated to this->first
*/
void hash_bucket::clear(){
    if(this->first != nullptr){
    	if(this->first->next != nullptr) delete this->first->next;
    	delete this->first;
    }
}

hash_table::hash_table(int table_size, int bucket_size, int num_rows, vector<int> key, vector<int> value){
	this->table_size = table_size;
	this->bucket_size = bucket_size;
	this->global_depth = 1;
	for(int i = 0; i < this->table_size; i++){
		hash_bucket* hb = new hash_bucket(i, 1);
		this->bucket_table.push_back(hb);
	}
	for(int i = 0; i < num_rows; i++){
		this->insert(key[i], value[i]);
	}
}

/* When insert collide happened, it needs to do rehash and distribute the entries in the bucket.
** Furthermore, if the global depth equals to the local depth, you need to extend the table size.
*/
void hash_table::extend(int id){
	hash_entry* curr = this->bucket_table[id]->first;
	vector<int> key;
	vector<int> value;
	int num = this->bucket_table[id]->num_entries;
	while(curr != nullptr){
		key.push_back(curr->key);
		value.push_back(curr->value);
		curr = curr->next;
	}
	this->bucket_table[id]->clear();
	int ld = this->bucket_table[id]->local_depth;
	int hk = this->bucket_table[id]->hash_key;
	for(int i = id; i < table_size; i = i + pow(2, ld)){
		this->bucket_table[i]->num_entries = 0;
		this->bucket_table[i]->local_depth++;
		bitset<32> b1 (i);
		if(b1[ld] == 0){
			this->bucket_table[i]->first = nullptr;
		}
		else{
			this->bucket_table[i]->first = nullptr;
			this->bucket_table[i]->hash_key = hk + pow(2, ld);
		}
	}
	for(int i = 0; i < num; i++){
		this->insert(key[i], value[i]);
	}
}

/* When construct hash_table you can call insert() in the for loop for each key-value pair.
*/
void hash_table::insert(int key, int value){
	bitset<32> b1 (key);
	bitset<32> b2 (0);
	int id = (b1 & ~(~b2 << this->global_depth)).to_ulong();
	int f = 0;
	hash_entry* tmp = this->bucket_table[id]->first;
	if(tmp == nullptr){
		this->bucket_table[id]->first = new hash_entry(key, value);
		for(int i = bucket_table[id]->hash_key; i < this->table_size; i = i + this->table_size / pow(2, (this->global_depth - this->bucket_table[id]->local_depth))){
			this->bucket_table[i]->num_entries++;
			this->bucket_table[i]->first = this->bucket_table[id]->first;
		}
	}
	else if(tmp->key == key){
		this->bucket_table[id]->first->value = value;
	}
	else{
		f = 0;
		while(tmp->next != nullptr){
			if(tmp->next->key == key){
				tmp->next->value = value;
				f = 1;
				break;
			}
			tmp = tmp->next;
		}
		if(f == 0){
			if(this->bucket_table[id]->num_entries < this->bucket_size){
				tmp->next = new hash_entry(key, value);
				for(int i = this->bucket_table[id]->hash_key; i < this->table_size; i = i + this->table_size / pow(2, (this->global_depth - this->bucket_table[id]->local_depth))){
					this->bucket_table[i]->num_entries++;
				}
			}
			else{
				if(this->bucket_table[id]->local_depth < this->global_depth){
					this->extend(this->bucket_table[id]->hash_key);
					this->insert(key, value);
				}
				else{
					for(int j = 0; j < this->table_size; j++){
						hash_bucket* hb = new hash_bucket(this->bucket_table[j]->hash_key, this->bucket_table[j]->local_depth);
						hb->num_entries = this->bucket_table[j]->num_entries;
						hb->first = this->bucket_table[j]->first;
						this->bucket_table.push_back(hb);
					}
					this->table_size *= 2;
					this->global_depth++;
					this->extend(this->bucket_table[id]->hash_key);
					this->insert(key, value);
				}
			}
		}
	}
}

/* The function might be called when shrink happened.
** Check whether the table necessory need the current size of table, or half the size of table
*/
void hash_table::half_table(){
    for(int i = this->table_size / 2; i < this->table_size; i++){
    	delete this->bucket_table[i];
    }
    this->table_size = this->table_size / 2;
    this->bucket_table.resize(this->table_size);
    this->global_depth--;
    int f = 0;
	for(int i = 0; i < this->table_size; i++){
		if(this->global_depth == this->bucket_table[i]->local_depth){
			f = 1;
			break;
		}
	}
	if(f == 0) this->half_table();
}

/* If a bucket with no entries, it need to check whether the pair hash index bucket 
** is in the same local depth. If true, then merge the two bucket and reassign all the 
** related hash index. Or, keep the bucket in the same local depth and wait until the bucket 
** with pair hash index comes to the same local depth.
*/
void hash_table::shrink(int id){
	bitset<32> b1 (id);
	int ld = this->bucket_table[id]->local_depth;
	if(this->bucket_table[id]->num_entries == 0 && ld != 1){
		if(b1[ld - 1] == 0){
			if(ld == this->bucket_table[id + pow(2, ld - 1)]->local_depth){
				this->isshrink = true;
				int ldp = this->bucket_table[id + pow(2, ld - 1)]->local_depth;
				for(int i = id; i < this->table_size; i = i + this->table_size / pow(2, (this->global_depth - ld))){
					this->bucket_table[i]->num_entries = this->bucket_table[id + pow(2, ld - 1)]->num_entries;
					this->bucket_table[i]->local_depth--;
					this->bucket_table[i]->first = this->bucket_table[id + pow(2, ld - 1)]->first;
				}
				for(int i = id + pow(2, ld - 1); i < this->table_size; i = i + this->table_size / pow(2, (this->global_depth - ldp))){
					this->bucket_table[i]->local_depth--;
					this->bucket_table[i]->hash_key = this->bucket_table[id]->hash_key;
				}
			}
		}
		else{
			if(ld == this->bucket_table[id - pow(2, ld - 1)]->local_depth){
				this->isshrink = true;
				int ldp = this->bucket_table[id - pow(2, ld - 1)]->local_depth;
				for(int i = id; i < this->table_size; i = i + this->table_size / pow(2, (this->global_depth - ld))){
					this->bucket_table[i]->num_entries = this->bucket_table[id - pow(2, ld - 1)]->num_entries;
					this->bucket_table[i]->local_depth--;
					this->bucket_table[i]->first = this->bucket_table[id - pow(2, ld - 1)]->first;
					this->bucket_table[i]->hash_key = this->bucket_table[id - pow(2, ld - 1)]->hash_key;
				}
				for(int i = id - pow(2, ld - 1); i < this->table_size; i = i + this->table_size / pow(2, (this->global_depth - ldp))){
					this->bucket_table[i]->local_depth--;
				}
			}
		}
	}
}

/* When executing remove_query you can call remove() in the for loop for each key.
*/
void hash_table::remove(int key){
	bitset<32> b1 (key);
	bitset<32> b2 (0);
	int id = (b1 & ~(~b2 << this->global_depth)).to_ulong();
	int f = 0;
	hash_entry* tmp = this->bucket_table[id]->first;
	/*//////////////////
	cout << key <<endl;
	for(int i = 0; i < this->table_size; i++){
		cout << this->bucket_table[i]->hash_key << ":" << this->bucket_table[i]->num_entries << " " << this->bucket_table[i]->local_depth << endl;
		hash_entry* curr = this->bucket_table[i]->first;
		while(curr != nullptr){
			cout << curr->key << endl;
			curr = curr->next;
		}
		cout << this->bucket_table[i]->first << endl;
		cout << "---------------------------------------------------" << endl;
	}
	cout << "////////////////////////////////////////////////" << endl;
	*///////////////////
	if(tmp != nullptr){
		if(tmp->key == key){
			for(int i = this->bucket_table[id]->hash_key; i < this->table_size; i = i + this->table_size / pow(2, (this->global_depth - this->bucket_table[id]->local_depth))){
				this->bucket_table[i]->num_entries--;
				this->bucket_table[i]->first = tmp->next;
			}
			delete tmp;
			tmp = nullptr;
		}
		else{
			f = 0;
			while(tmp->next != nullptr){
				if(tmp->next->key == key){
					hash_entry* curr = tmp->next;
					tmp->next = tmp->next->next;
					delete curr;
					curr = nullptr;
					f = 1;
					break;
				}
				tmp = tmp->next;
			}
			if(f == 1){
				for(int i = bucket_table[id]->hash_key; i < this->table_size; i = i + this->table_size / pow(2, (this->global_depth - this->bucket_table[id]->local_depth))){
					this->bucket_table[i]->num_entries--;
				}
			}
		}
	}
	/*//////////////////
	cout << key <<endl;
	for(int i = 0; i < this->table_size; i++){
		cout << this->bucket_table[i]->hash_key << ":" << this->bucket_table[i]->num_entries << " " << this->bucket_table[i]->local_depth << endl;
		hash_entry* curr = this->bucket_table[i]->first;
		while(curr != nullptr){
			cout << curr->key << endl;
			curr = curr->next;
		}
		cout << this->bucket_table[i]->first << endl;
		cout << "---------------------------------------------------" << endl;
	}
	cout << "////////////////////////////////////////////////" << endl;
	*///////////////////
}

void hash_table::key_query(vector<int> query_keys, string file_name){
    ofstream out;
    out.open(file_name);
    int f = 0;
    for(int i = 0; i < query_keys.size(); i++){
    	bitset<32> b1 (query_keys[i]);
		bitset<32> b2 (0);
		int id = (b1 & ~(~b2 << this->global_depth)).to_ulong();
		hash_entry* curr = this->bucket_table[id]->first;
		f = 0;
		while(curr != nullptr){
			if(query_keys[i] == curr->key){
				out << curr->value << "," << this->bucket_table[id]->local_depth << "\n";
				f = 1;
				break;
			}
			curr = curr->next;
		}
		if(f == 0) out << "-1," << this->bucket_table[id]->local_depth << "\n";
    }
    out.close();
}

void hash_table::remove_query(vector<int> query_keys){
    for(int i = 0; i < query_keys.size(); i++){
    	this->remove(query_keys[i]);
    }
    while(this->isshrink){
    	this->isshrink = false;
    	for(int i = 0; i < this->table_size; i++){
    		shrink(this->bucket_table[i]->hash_key);
    	}
    	int f = 0, m = 0;
		for(int i = 0; i < this->table_size; i++){
			m = max(m, this->bucket_table[i]->local_depth);
		}
		while(this->global_depth > m) this->half_table();
    }
}

/* Free the memory that you have allocated in this program
*/
void hash_table::clear(){
	vector<int> visited(this->table_size, 0);
	for(int i = 0; i < this->table_size; i++){
		if(visited[i] == 0){
			for(int j = this->bucket_table[i]->hash_key; j < this->table_size; j = j + this->table_size / pow(2, (this->global_depth - this->bucket_table[i]->local_depth))){
				visited[j] = 1;
			}
			this->bucket_table[i]->clear();
		}
	}
	for(int i = 0; i < this->table_size; i++){
		delete bucket_table[i];
	}
	bucket_table.clear();
}
