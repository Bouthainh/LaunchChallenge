import SwiftUI

struct CanvasView: View {
    @State private var vm = CanvasViewModel()

    var body: some View {
        @Bindable var vm = vm

        ZStack {
            AppTheme.background.ignoresSafeArea()
            canvas(vm: vm)
        }
        
        .sheet(item: $vm.sheet) { sheet in
            sheetContent(sheet, vm: vm)
        }
        .alert(vm.editingID == nil ? "إضافة نص" : "تعديل النص",
               isPresented: $vm.showTextAlert) {
            TextField("نصك", text: $vm.textDraft)
            Button(vm.editingID == nil ? "إضافة" : "حفظ") { vm.commitText() }
            Button("إلغاء", role: .cancel) {
                vm.textDraft = ""
                vm.editingID = nil
            }
        }

    }

    private func canvas(vm: CanvasViewModel) -> some View {
        @Bindable var vm = vm

        return ZStack {
            Rectangle()
                .fill(vm.canvasColor)
                .overlay(alignment: .topTrailing) {
                    Image("BackgroundDesign")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140)
                        .padding(.top, 100)
                        .allowsHitTesting(false)
                }
                .contentShape(Rectangle())
                .onTapGesture { vm.selectedID = nil }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("لوحتــك")
                    .font(.custom(AppTheme.displayFontName, size: 35))
                    .foregroundStyle(AppTheme.titleText)
                Text("أطلق إبداعــك… هذه مساحتــك الخاصــة")
                    .font(.custom(AppTheme.textFontName, size: 22))
                    .foregroundStyle(AppTheme.bodyText)
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 170)
            .frame(maxHeight: .infinity, alignment: .top)
            .allowsHitTesting(false)
            
            
            ForEach($vm.elements) { $element in
                let id = element.id
                CanvasElementView(
                    element: $element,
                    isSelected: vm.selectedID == id,
                    onSelect: { vm.selectedID = id },
                    onEdit: { vm.startEditing(id) },
                    onFont: { vm.select(id, opening: .font) },
                    onTextColor: { vm.select(id, opening: .colors) },
                    onFront: { vm.bringToFront(id) },
                    onDelete: { vm.delete(id) }
                )
                .allowsHitTesting(!vm.isDrawing)
            }

            PencilCanvas(drawing: $vm.drawing, isActive: vm.isDrawing)
                .allowsHitTesting(vm.isDrawing)
        }
        .overlay(alignment: .leading) {
            toolbar(vm: vm).padding(.leading, 14)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
    private let inactiveTint = Color.white.opacity(0.9)
    
    private func toolbar(vm: CanvasViewModel) -> some View {
        VStack(spacing: 22) {
            assetToolButton("tab_bag",
                            tint: vm.sheet == .bag ? AppTheme.tabSelected : inactiveTint) {
                vm.isDrawing = false
                vm.sheet = .bag
            }

            toolButton("paintpalette.fill",
                       tint: vm.sheet == .colors ? AppTheme.tabSelected : inactiveTint) {
                vm.isDrawing = false
                vm.sheet = .colors
            }

            toolButton("character.textbox",
                       tint: vm.showTextAlert ? AppTheme.tabSelected : inactiveTint) {
                vm.startAddingText()
            }

            toolButton("pencil.tip.crop.circle",
                       tint: vm.isDrawing ? AppTheme.tabSelected : inactiveTint) {
                vm.selectedID = nil
                vm.isDrawing.toggle()
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(Capsule().fill(.ultraThinMaterial))
        .environment(\.colorScheme, .dark)
    }

    private func toolButton(_ systemName: String,
                            tint: Color = .secondary,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 26))
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
        }
    }
    private func assetToolButton(_ imageName: String,
                                 tint: Color = .secondary,
                                 action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
        }
    }

    @ViewBuilder
    private func sheetContent(_ sheet: CanvasViewModel.Sheet, vm: CanvasViewModel) -> some View {
        switch sheet {
        case .bag:
            BagPickerSheet(items: vm.availableStickers) { sticker in
                vm.addSticker(sticker)
                vm.sheet = nil
            }
            .presentationDetents([.height(260)])
            .presentationDragIndicator(.visible)

        case .colors:
            ColorSheet(title: vm.selectedText != nil ? "لون النص" : "لون اللوحة") { color in
                vm.applyColor(color)
            }
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.visible)

        case .font:
            FontSheet(hasText: vm.selectedText != nil,
                      style: vm.fontStyleBinding,
                      size: vm.fontSizeBinding)
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    CanvasView()
}
