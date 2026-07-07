import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingItem: Batch?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        Button {
                            editingItem = item
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.scentName.isEmpty ? "Untitled" : item.scentName)
                                    .font(Theme.titleFont)
                                    .foregroundStyle(.white)
                                Text("\(item.oilRatio)")
                                    .font(Theme.bodyFont)
                                    .foregroundStyle(Theme.accent2)
                            }
                            .padding(.vertical, 6)
                        }
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .accessibilityIdentifier("itemList")
            }
            .navigationTitle("Batch Wick")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EditItemView(item: nil) { newItem in
                    store.add(newItem)
                }
            }
            .sheet(item: $editingItem) { item in
                EditItemView(item: item) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.accent)
    }
}

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: Batch
    let onSave: (Batch) -> Void
    private let isNew: Bool

    init(item: Batch?, onSave: @escaping (Batch) -> Void) {
        _draft = State(initialValue: item ?? Batch())
        self.onSave = onSave
        self.isNew = item == nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Scent name", text: $draft.scentName)
                        .accessibilityIdentifier("field_scentName")
                    HStack {
                        Text("Oil ratio (%)")
                        Spacer()
                        TextField("Oil ratio (%)", value: $draft.oilRatio, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("field_oilRatio")
                    }
                    HStack {
                        Text("Container size (oz)")
                        Spacer()
                        TextField("Container size (oz)", value: $draft.containerSize, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("field_containerSize")
                    }
                    TextField("Base type", text: $draft.baseType)
                        .accessibilityIdentifier("field_baseType")
                    TextField("Throw notes", text: $draft.throwNotes)
                        .accessibilityIdentifier("field_throwNotes")
                }
            }
            .navigationTitle(isNew ? "New Batch" : "Edit Batch")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
