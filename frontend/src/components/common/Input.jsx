import React from 'react'

export function Input({
    label,
    error,
    className = '',
    ...props
}) {
    return (
        <div className={`mb-4 ${className}`}>
            {label && (
                <label className="block text-sm font-medium text-gray-700 mb-1.5">
                    {label}
                </label>
            )}
            <input
                className={`w-full px-4 py-2 rounded-lg border bg-white/50 focus:ring-2 outline-none transition-all duration-200 
          ${error
                        ? 'border-red-300 focus:border-red-500 focus:ring-red-200'
                        : 'border-gray-200 focus:border-blue-500 focus:ring-blue-200'
                    }`}
                {...props}
            />
            {error && (
                <p className="mt-1 text-sm text-red-600">{error}</p>
            )}
        </div>
    )
}
