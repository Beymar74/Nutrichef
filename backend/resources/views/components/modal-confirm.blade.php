@props(['id', 'title', 'message', 'action', 'confirmText' => 'Eliminar', 'cancelText' => 'Cancelar'])

<div id="{{ $id }}" class="fixed inset-0 z-50 hidden" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <!-- Fondo oscuro (Backdrop) -->
    <div class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm transition-opacity opacity-0" id="{{ $id }}-backdrop"></div>

    <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
            
            <!-- Panel del Modal -->
            <div class="relative transform overflow-hidden rounded-2xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95" id="{{ $id }}-panel">
                
                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div class="sm:flex sm:items-start">
                        <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                            <i data-lucide="alert-triangle" class="h-6 w-6 text-red-600"></i>
                        </div>
                        <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                            <h3 class="text-lg font-semibold leading-6 text-slate-900" id="modal-title">{{ $title }}</h3>
                            <div class="mt-2">
                                <p class="text-sm text-slate-500">{{ $message }}</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="bg-slate-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 border-t border-slate-100 gap-2">
                    <!-- Formulario de Acción -->
                    <form id="{{ $id }}-form" action="{{ $action }}" method="POST">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="inline-flex w-full justify-center rounded-lg bg-red-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-red-500 sm:ml-3 sm:w-auto transition-colors">
                            {{ $confirmText }}
                        </button>
                    </form>
                    
                    <button type="button" onclick="closeModal('{{ $id }}')" class="mt-3 inline-flex w-full justify-center rounded-lg bg-white px-4 py-2.5 text-sm font-semibold text-slate-900 shadow-sm ring-1 ring-inset ring-slate-300 hover:bg-slate-50 sm:mt-0 sm:w-auto transition-colors">
                        {{ $cancelText }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>