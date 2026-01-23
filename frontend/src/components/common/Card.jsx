import React from 'react'

export function Card({ children, className = '', title, subtitle }) {
    return (
        <div className={`glass-card p-6 ${className}`}>
            {(title || subtitle) && (
                <div className="mb-6">
                    {title && <h3 className="text-xl font-bold text-gray-900">{title}</h3>}
                    {subtitle && <p className="text-sm text-gray-500 mt-1">{subtitle}</p>}
                </div>
            )}
            {children}
        </div>
    )
}
